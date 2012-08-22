#define MAX_LOCATION_LIFETIME 3000 // In seconds
#define MIN_LOCATION_ACCURACY 300 // In meters
#define LOCATION_SERVICE_TIMEOUT 5 // In seconds

#import "LocationManager.h"
#import "ConvenientPopups.h"

@interface LocationManager()

- (void)startLocationService;
- (void)stopLocationService;
- (BOOL)returnLocation;

@end


@implementation LocationManager


static CLLocationManager* locationManager;

static CLLocation* userLocation;

static BOOL locationUpdated;
static double getUserLocationRunTimestamp;

static NSDate* lastUpdate;
static NSMutableArray* delegates;

static LocationManager *sharedInstance;

+ (LocationManager *)instance
{
	return sharedInstance;
}

+ (void)initialize
{
    static BOOL initialized = NO;
    
    if(!initialized)
    {
        initialized = YES;
		
		sharedInstance = [[LocationManager alloc] init];
        delegates = [[NSMutableArray alloc] init];
        
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = sharedInstance;
        locationManager.distanceFilter = 100;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
}

- (void)setUserLocation:(CLLocation*)location
{
    userLocation = location;
    lastUpdate = [NSDate date];
    locationUpdated = YES;
    
    [self returnLocation];
}

- (void)startWithDelegate:(id<LocationManagerDelegate>)delegate implicitly:(BOOL)implicitly
{    
    getUserLocationRunTimestamp = [[NSDate date] timeIntervalSince1970];
    
    if(delegate != nil)
    if([delegates count] == 0 || [delegates indexOfObject:delegate] != NSNotFound)
    {
        [delegates addObject: delegate];
    }
    
    // If it takes too long to find user location - send locationNotFound
    if(!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:LOCATION_SERVICE_TIMEOUT 
                                                  target:self
                                                selector:@selector(timeout:) 
                                                userInfo:nil 
                                                 repeats:NO];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer 
                                     forMode:NSDefaultRunLoopMode];
    }
    
    BOOL locationExpired = [[NSDate date] timeIntervalSinceDate:lastUpdate] > MAX_LOCATION_LIFETIME;
    
    if(implicitly || lastUpdate == nil || locationExpired)
    {
        [self startLocationService];
    }
    else
    {
        [self returnLocation];
    }
}

- (CLLocation*)getLastLocation
{
    return userLocation;
}

- (void) stopAndRemoveAllDelegates
{
    [self stopLocationService];
    [delegates removeAllObjects];
}

- (void)removeDelegate:(id)delegate
{
    if(delegate != nil)
    if([delegates count] > 0 && ([delegates indexOfObject:delegate] != NSNotFound))
    {
        [delegates removeObject:delegate];
    }
}

#pragma mark - Private

- (BOOL)returnLocation
{
    [self stopLocationService];

    
    if(userLocation == nil)
    {
        return NO;
    }
    else
    {
        while ([delegates count] > 0)
        {
            id<LocationManagerDelegate> delegate = [delegates objectAtIndex:0];
            [delegate locationFound:userLocation isNew:locationUpdated];
            [delegates removeObject:delegate];
        }
        
        [delegates removeAllObjects];
        
        return YES;
    }
}

- (void)returnBadAccuracyLocation
{
    for(int i = 0; i < [delegates count]; ++i)
    {
        id<LocationManagerDelegate> delegate = [delegates objectAtIndex:i];
        if([delegate respondsToSelector:@selector(badAccuracylocationFound:)])
            [delegate badAccuracylocationFound:userLocation];
    }
}

- (void)startLocationService
{
    [locationManager startUpdatingLocation];
}

- (void) stopLocationService
{
    [locationManager stopUpdatingLocation];
}

- (void)timeout:(id) timer
{
    [self locationManager:nil didFailWithError:nil];
}

#pragma mark - CLLocationManagerDelegate methods

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [_timer invalidate];
    _timer = nil;
    
    [self stopLocationService];
    
    // Block other threads until completed
    @synchronized(self)
    {
        for(id<LocationManagerDelegate> delegate in delegates)
        {
            [delegate locationNotFound];
        }
        
        [delegates removeAllObjects];
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{     
    [_timer invalidate];
    _timer = nil;
        
    BOOL locationExpired = [[NSDate date] timeIntervalSinceDate:newLocation.timestamp] > MAX_LOCATION_LIFETIME;
    BOOL goodAccuracy = newLocation.horizontalAccuracy < MIN_LOCATION_ACCURACY;
    BOOL timeout = [[NSDate date] timeIntervalSince1970] - getUserLocationRunTimestamp > LOCATION_SERVICE_TIMEOUT;
    
    if((!locationExpired && goodAccuracy) || timeout)
    {
        [self stopLocationService];
        userLocation = newLocation;
    
        [self returnLocation];
        lastUpdate = [NSDate date];
    }
    else
    {
        userLocation = newLocation;
        [self returnBadAccuracyLocation];

    }
}

@end