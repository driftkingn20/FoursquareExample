/*
 This class handles requests to remote servers via ASIHTTP library and parsing JSON response
 */

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@class RequestProcessor;

@protocol RequestProcessorDelegate <NSObject>

@optional

// Default callbacks. You can set your own custom callbacks in successCallback and failCallback properties
- (void)requestProcessorSuccessCallback:(RequestProcessor *)processor;
- (void)requestProcessorFailedCallback:(RequestProcessor *)processor;

@end

typedef enum{
    kRequestTypeInternal = 0,
    kRequestTypeNonInternal
} RequestType;

@interface RequestProcessor : NSObject {
    SEL requestSuccessful;
    SEL requestFailed;
    
    NSInteger _offset;
    NSInteger _limit;
    
    ASIHTTPRequest *_request;
    ASIFormDataRequest *_formRequest;
    
    RequestType _requestType;
    BOOL _parameterAdded;
}

@property (nonatomic, retain) NSString *urlString;

@property (nonatomic, retain) NSMutableDictionary *processedJSON;
@property (nonatomic, assign) id delegate;

// Use this properties to set custom callbacks instead of default
@property (nonatomic, assign) SEL successCallback;
@property (nonatomic, assign) SEL failCallback;


+ (NSString *) urlEncode: (id) unencodedString;
+ (void)cancelAllRequestsFromDelegate:(id)delegate;

- (void)startRequest;

- (void)cancelRequest;

- (void)process:(NSString *) stringToProcess;

// Requests
- (void)getFoursquareVenuesForLocation:(CLLocation *)location
                                radius:(NSString *)radius
                                 query:(NSString *)query
                           limitToFood:(BOOL)limitToFood;

@end