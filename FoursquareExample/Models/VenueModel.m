#import "VenueModel.h"

@implementation VenueModel

-  (id)initWithDictionary:(NSDictionary *)aDictionary
{
    self = [super init];
    
    if(self)
    {
        NSString *venueName = [aDictionary valueForKeyPath:@"venue.name"];
        
        if([venueName isKindOfClass:[NSString class]])
            self.name = venueName;
        else
            self.name = @"";
    }
    
    return self;
}

@end
