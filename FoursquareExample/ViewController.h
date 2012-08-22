/*
 This is the main (and only) view controller
 */

#import <UIKit/UIKit.h>
#import "LocationManager.h"
#import "RequestProcessor.h"

@interface ViewController : UIViewController<LocationManagerDelegate, RequestProcessorDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    IBOutlet UITableView *_tableView;
    IBOutlet UITextField *_textField;
    IBOutlet UIButton *_cancelButton;
}

- (IBAction)refresh;
- (IBAction)hideKeyboard;

@end
