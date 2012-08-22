/*
 This class realizes convenient way to show nonblocking popups and toast-like messages
 */

#import <Foundation/Foundation.h>

@interface ConvenientPopups : NSObject 
{

}

+ (void)showAlertWithTitle:(NSString *) title 
				andMessage:(NSString *) message;

+ (void)showNonBlockingPopupOnView:(UIView *)aView
						  withText:(NSString *)aText;

+ (void)closeNonBlockingPopupOnView:(UIView *)aView;

+ (void)showToastLikeMessage:(NSString *)message
                      onView:(UIView *)aView;

@end
