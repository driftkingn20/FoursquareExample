/*
 A simple model for Foursquare venue - it can easily be extended to include other data
 */

#import <Foundation/Foundation.h>

@interface VenueModel : NSObject

@property (strong, nonatomic) NSString *name;

-  (id)initWithDictionary:(NSDictionary *)aDictionary;

@end
