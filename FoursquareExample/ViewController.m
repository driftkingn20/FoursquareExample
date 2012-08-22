#import "ViewController.h"
#import "ConvenientPopups.h"
#import "Config.h"
#import "FoursquareExploreModel.h"

@interface ViewController ()
{    
    FoursquareExploreModel *_exploreModel;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _cancelButton.alpha = 0;
    
    // Find user location and load data right after load
    [self refresh];
}

#pragma mark - UI actions

- (IBAction)refresh
{
    [_textField resignFirstResponder];
    [ConvenientPopups showNonBlockingPopupOnView:self.view withText:@"Updating your location..."];
    [[LocationManager instance] startWithDelegate:self implicitly:YES];
}

- (IBAction)hideKeyboard
{
    [_textField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:DEFAULT_ANIMATION_INTERVAL
                     animations:^{
                         _cancelButton.alpha = 0;
                     }];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:DEFAULT_ANIMATION_INTERVAL
                     animations:^{
                         _cancelButton.alpha = 1;
                     }];
    return YES;
}

#pragma mark - LocationManagerDelegate

- (void)locationFound:(CLLocation*)location isNew:(BOOL)newLocation
{    
    [ConvenientPopups closeNonBlockingPopupOnView:self.view];
    [ConvenientPopups showNonBlockingPopupOnView:self.view withText:@"Fetching places..."];
    
    
    RequestProcessor *rp = [[RequestProcessor alloc] init];
    rp.delegate = self;
    rp.successCallback = @selector(venuesLoaded:);
    rp.failCallback = @selector(venuesFailedToLoad:);
    [rp getFoursquareVenuesForLocation:location
                                radius:_textField.text
                                 query:nil
                           limitToFood:YES];
}

- (void)locationNotFound;
{
    [ConvenientPopups showAlertWithTitle:@""
                              andMessage:@"Your location cannot be found - we will use New York as a default location"];
    
    [ConvenientPopups closeNonBlockingPopupOnView:self.view];
    [ConvenientPopups showNonBlockingPopupOnView:self.view withText:@"Fetching places..."];
    
    RequestProcessor *rp = [[RequestProcessor alloc] init];
    rp.delegate = self;
    rp.successCallback = @selector(venuesLoaded:);
    rp.failCallback = @selector(venuesFailedToLoad:);
    [rp getFoursquareVenuesForLocation:DEFAULT_LOCATION
                                radius:_textField.text
                                 query:nil
                           limitToFood:YES];
}

#pragma mark - RequestProcessorDelegate

- (void)venuesLoaded:(RequestProcessor *)rp
{
    [ConvenientPopups closeNonBlockingPopupOnView:self.view];
    
    // Convert dictionary into a model
    _exploreModel = [[FoursquareExploreModel alloc] initWithDictionary:rp.processedJSON];
    
    [_tableView reloadData];
}

- (void)venuesFailedToLoad:(RequestProcessor *)rp
{
    [ConvenientPopups closeNonBlockingPopupOnView:self.view];
    [ConvenientPopups showToastLikeMessage:@"Error loading results from foursquare!" onView:self.view];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_exploreModel)
        return [_exploreModel.venues count];
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"venue cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    VenueModel *currentItem = [_exploreModel.venues objectAtIndex:indexPath.row];
    cell.textLabel.text = currentItem.name;
    return cell;
}

@end