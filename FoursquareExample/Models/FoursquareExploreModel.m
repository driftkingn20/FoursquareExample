#import "FoursquareExploreModel.h"

@implementation FoursquareExploreModel

-  (id)initWithDictionary:(NSDictionary *)aDictionary
{
    self = [super init];
    
    if(self)
    {
        NSArray *venuesWrap = [aDictionary valueForKeyPath:@"response.groups.items"];
        
        if([venuesWrap isKindOfClass:[NSArray class]] && [venuesWrap count])
        {
            NSArray *venues =  [venuesWrap objectAtIndex:0];
            
            if([venues isKindOfClass:[NSArray class]])
            {
                self.venues = [[NSMutableArray alloc] initWithCapacity:[venues count]];
                
                for(NSDictionary *venue in venues)
                {
                    if(![venue isKindOfClass:[NSDictionary class]])
                        continue;
                    
                    VenueModel *vm = [[VenueModel alloc] initWithDictionary:venue];
                    if(vm)
                        [self.venues addObject:vm];
                }
            }
        }
    }
    
    return self;
}

@end
