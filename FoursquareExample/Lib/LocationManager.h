/*
 Class responsible for finding user location
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationManagerDelegate <NSObject>

- (void) locationFound:(CLLocation*) location isNew:(BOOL)newLocation;
- (void) locationNotFound;

@optional

- (void) badAccuracylocationFound:(CLLocation*) location;

@end

@interface LocationManager : NSObject <CLLocationManagerDelegate>
{
    NSTimer *_timer;
}

// Start location service and add a delegate
- (void)startWithDelegate:(id<LocationManagerDelegate>)delegate implicitly:(BOOL)implicitly;

// Sets user location manually
- (void)setUserLocation:(CLLocation*)location;

- (CLLocation*)getLastLocation;

- (void)stopAndRemoveAllDelegates;
- (void)removeDelegate:(id)delegate;

+ (void)initialize;
+ (LocationManager *)instance;

@end
