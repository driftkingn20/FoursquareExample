#import "ConvenientPopups.h"
#import <QuartzCore/QuartzCore.h> // For rounded corners

#define LOADING_VIEW_TAG 456987123 // Some random number

@implementation ConvenientPopups

+ (void)showAlertWithTitle:(NSString *) title 
				andMessage:(NSString *) message
{    
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:title
										   message:message 
										  delegate:self 
								 cancelButtonTitle:@"OK" 
								 otherButtonTitles:nil];
	
	[av show];
}

+ (void)showNonBlockingPopupOnView:(UIView *)aView
						  withText:(NSString *)aText
{    
	static const CGFloat height = 70;
    static const CGFloat width = 240;
    static const CGFloat cornerRadius = 10;
    
    __block UIView *loadingView = 
    [[UIView alloc] initWithFrame:CGRectMake((aView.bounds.size.width-width)/2,
                                             (aView.bounds.size.height-height)/2, 
                                             width, 
                                             height)];
	loadingView.tag = LOADING_VIEW_TAG;
    loadingView.layer.cornerRadius = cornerRadius;
	loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    CGFloat aiOffset = (loadingView.frame.size.height - ai.frame.size.height)/2;
    ai.frame = CGRectMake(aiOffset, aiOffset, ai.frame.size.width, ai.frame.size.height);
    [loadingView addSubview:ai];
    [ai startAnimating];
    
    CGFloat labelOffset = aiOffset * 2 + ai.frame.size.width;
    
	UILabel *loadingLabel = 
    [[UILabel alloc] initWithFrame:CGRectMake(labelOffset, 
                                              aiOffset, 
                                              width - labelOffset - aiOffset, 
                                              ai.frame.size.height)];
    loadingLabel.numberOfLines = 0;
	loadingLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
	loadingLabel.text = aText;
	loadingLabel.textColor = [UIColor whiteColor];
	loadingLabel.backgroundColor = [UIColor clearColor];
	[loadingView addSubview:loadingLabel];
    
    CGSize constraintSize = CGSizeMake(loadingLabel.frame.size.width, 120);
    CGFloat delta = [aText sizeWithFont:loadingLabel.font 
                      constrainedToSize:constraintSize 
                          lineBreakMode:loadingLabel.lineBreakMode].height - loadingLabel.frame.size.height;
    delta = MAX(delta, 0);
    CGRect frame;
    
    frame = loadingLabel.frame;
    frame.size.height += delta;
    loadingLabel.frame = frame;
    
    frame = loadingView.frame;
    frame.size.height += delta;
    loadingView.frame = frame;

	
	[aView addSubview:loadingView];
}

+ (void)closeNonBlockingPopupOnView:(UIView *)aView
{
    UIView *loadingView = [aView viewWithTag:LOADING_VIEW_TAG];
	[loadingView removeFromSuperview];
}

+ (void)showToastLikeMessage:(NSString *)message
                      onView:(UIView *)aView
{
    static const CGFloat height = 70;
    static const CGFloat width = 240;
    static const CGFloat cornerRadius = 10;
    static const CGFloat labelOffset = 10;
    
    __block UIView *blockerView =
    [[UIView alloc] initWithFrame:CGRectMake(0,
                                             0,
                                             aView.bounds.size.width,
                                             aView.bounds.size.height)];
    blockerView.backgroundColor = [UIColor blackColor];
    blockerView.alpha = 0.5f;
    [aView addSubview:blockerView];
    
    __block UIView *toastView =
    [[UIView alloc] initWithFrame:CGRectMake((aView.bounds.size.width-width)/2,
                                             (aView.bounds.size.height-height)/2,
                                             width,
                                             height)];
	
    toastView.layer.cornerRadius = cornerRadius;
	toastView.backgroundColor = [UIColor colorWithRed:242/255.0f
                                                  green:239/255.0f
                                                   blue:234/255.0f
                                                  alpha:1.0f];

    
	UILabel *label =
    [[UILabel alloc] initWithFrame:CGRectMake(labelOffset,
                                              labelOffset,
                                              width - labelOffset*2,
                                              height - labelOffset*2)];
    label.numberOfLines = 0;
	label.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
	label.text = message;
	label.textColor = [UIColor blackColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0, 1);
	label.backgroundColor = [UIColor clearColor];
	[toastView addSubview:label];
    
    CGSize constraintSize = CGSizeMake(label.frame.size.width, 120);
    CGFloat delta = [message sizeWithFont:label.font
                        constrainedToSize:constraintSize
                            lineBreakMode:label.lineBreakMode].height - label.frame.size.height;
    delta = MAX(delta, 0);
    CGRect frame;
    
    frame = label.frame;
    frame.size.height += delta;
    label.frame = frame;
    
    frame = toastView.frame;
    frame.size.height += delta;
    toastView.frame = frame;

	
	[aView addSubview:toastView];
	
    
    [UIView animateWithDuration:1.0f
                          delay:1.0f
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         toastView.alpha = 0.0f;
                         blockerView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [toastView removeFromSuperview];
                         [blockerView removeFromSuperview];
                     }];
}

@end
