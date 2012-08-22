/*
 A model for "explore" Foursquare API method
 */

#import <Foundation/Foundation.h>
#import "VenueModel.h"

@interface FoursquareExploreModel : NSObject

@property (strong, nonatomic) NSMutableArray *venues;

-  (id)initWithDictionary:(NSDictionary *)aDictionary;

@end
