//
//  BFFAddItemViewController.m
//  Borrow From Friends
//
//  Created by Nikhil Khanna on 2/16/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import "BFFAddItemViewController.h"
#import "Appirater.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"
#import "GAIFields.h"
@interface BFFAddItemViewController () <FBFriendPickerDelegate, UISearchBarDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIStepper *amountStepper;
@property (weak, nonatomic) IBOutlet UILabel *amountField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *borrowedSwitch;
//@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;
@end

@implementation BFFAddItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
	// Do any additional setup after loading the view.
    self.friendPickerController = nil;
    self.searchBar = nil;
    self.amountField.textAlignment = NSTextAlignmentCenter;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Add Item"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}


- (void)addSearchBarToFriendPickerView
{
    if(self.searchBar == nil)
    {
        CGFloat searchBarHeight = 44.0;
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, searchBarHeight)];
        self.searchBar.autoresizingMask = self.searchBar.autoresizingMask | UIViewAutoresizingFlexibleWidth;
        self.searchBar.delegate = self;
        self.searchBar.showsCancelButton = YES;
        
        [self.friendPickerController.canvasView addSubview:self.searchBar];
        CGRect newFrame = self.friendPickerController.view.bounds;
        newFrame.size.height -= searchBarHeight;
        newFrame.origin.y = searchBarHeight;
        self.friendPickerController.tableView.frame = newFrame;
    }
}

- (void)dismissKeyboard
{
    [self.nameField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadFriendPicker
{
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error) {
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                    message:error.localizedDescription
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                          } else if (session.isOpen) {
                                              [self loadFriendPicker];
                                          }
                                      }];
        return;
    }
    if (self.friendPickerController == nil) {
        // Create friend picker, and get data loaded into it.
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerController.title = @"Pick Friends";
        self.friendPickerController.delegate = self;
        self.friendPickerController.allowsMultipleSelection = NO;
    }
    self.friendPickerController.title = @"Which friend?";
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    
    [self presentViewController:self.friendPickerController animated:YES completion:^(void){
        [self addSearchBarToFriendPickerView];
    }];
    
}

//if submit is hit, checks pluralization before takes you to friendpicker page
- (IBAction)pickFriendsButtonClick:(id)sender
{
    if([[self.nameField.text stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] ==0)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"No Item Name" message:@"Please enter an item name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(self.amountStepper.value > 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Good to go?" message:@"Did you pluralize your item name?" delegate:self cancelButtonTitle:@"Let me change it" otherButtonTitles:@"It's pluralized", nil];
        
        [alert show];
    }
    else
    {
        [self goToFriendPicker];
    }
}

//alert view delegate method. handles buttons clicks
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //if "It's pluralized" (the OK) button is clicked
    if(buttonIndex != [alertView cancelButtonIndex])
    {
        [self goToFriendPicker];
    }
}

- (void)goToFriendPicker
{
    self.name = [self stringByTrimmingLeadingWhitespace:self.nameField.text];
    self.amount = [NSNumber numberWithInt:(int)self.amountStepper.value];
    //if its the first segment (i.e. lent it) set it to true else it'll be false
    self.lent = self.borrowedSwitch.selectedSegmentIndex == 0;
    [self loadFriendPicker];
}

//Updates the title of the friendpicker when a user is selected
//TODO: Not working. It could be that I'm detecting touches in the view incorrectly. 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.friendPickerController != nil)
    {
        if(self.friendPickerController.selection != nil)
        {
            id<FBGraphUser> user = self.friendPickerController.selection.firstObject;
            self.friendPickerController.title = [NSString stringWithFormat:@"%@?", user.first_name];
        }
    }
}

- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//called when the stepper changes value
- (IBAction)valueChanged:(UIStepper *)sender
{
    self.amountField.text = [NSString stringWithFormat:@"Amount: %d", (int)sender.value];
    
}

//called when friend picker done is pressed
- (void)facebookViewControllerDoneWasPressed:(id)sender
{
    //no one selected show the toast
    if(self.friendPickerController.selection.count == 0)
    {
        Toast* t = [Toast toastWithMessage:@"Please select a friend"];
        [t showOnView:self.friendPickerController.view];
        return;
    }
    else
    {
        //loading indicator
        UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        activityView.center=self.view.center;
        
        [activityView startAnimating];
        
        [self.view addSubview:activityView];
        
        //adding the stuff
        id<FBGraphUser> user = self.friendPickerController.selection.firstObject;
        
        //self.navigationController.title = [NSString stringWithFormat:@"%@?", user.name]; // change the title of the view to show selected name //TODO: Place this as soon as a user is selected, not when done is pressed. 
        
        NSURL *profilePictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?", user.id]];
        NSData *picData = [NSData dataWithContentsOfURL:profilePictureURL];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //the dictionary that stores a single transaction
        NSDictionary* itemDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool: self.lent], isLentKey,
                                  self.amount,amountKey,self.name,itemNameKey, user.id,userIDKey,user.first_name, userFirstKey, user.name,userNameKey,picData, profilePictureDataKey, nil];
        //adds the dictionary to the transaction array (creating array if one doesn't exist)
        NSMutableArray* transactionArray;
        if([defaults objectForKey:transactionArrayKey]==nil)
        {
            transactionArray = [[NSMutableArray alloc] init];
        }
        else
        {
            transactionArray = [[defaults objectForKey:transactionArrayKey] mutableCopy];
        }
        [transactionArray addObject:itemDict];
        [defaults setObject:transactionArray forKey:transactionArrayKey];
        [defaults synchronize];
        
        
        //analytics to log the item
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker set:kGAIScreenName value:@"Add Item"];
        NSString* actionName;
        if(self.lent)
        {
            actionName = [NSString stringWithFormat:@"%@ lent",[[NSUserDefaults standardUserDefaults] objectForKey:currentUserIdKey]];
        }
        else
        {
            actionName = [NSString stringWithFormat:@"%@ borrowed",[[NSUserDefaults standardUserDefaults] objectForKey:currentUserIdKey]];
        }
        [tracker send:[[GAIDictionaryBuilder
                        createEventWithCategory:@"Create Transaction"
                        action:actionName
                        label:[NSString stringWithFormat:@"friend:%@, amount:%d, itemname:%@",
                               user.id, [self.amount intValue],self.name]
                        value:nil] build]];
        [tracker set:kGAIScreenName value:nil];
        
        [self dismissViewControllerAnimated:NO completion:^() {
            [self performSegueWithIdentifier:@"mainSegue" sender:self];
            [Appirater userDidSignificantEvent:YES];
        }];
 
    }
}
-(NSString*)stringByTrimmingLeadingWhitespace:(NSString* )string {
    NSInteger i = 0;
    
    while ((i < [string length])
           && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[string characterAtIndex:i]]) {
        i++;
    }
    return [string substringFromIndex:i];
}
// loads the data of the search locally
- (void)handleSearchBar:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.searchText = searchBar.text;
    [self.friendPickerController updateView];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self handleSearchBar:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchText = nil;
    [searchBar resignFirstResponder];
    [self.friendPickerController updateView]; //ANEESH FIGURED THIS OUT. It kind of fixes the list reset problem.
}

// FBFriendPickerDelegate method. Updates which friends to show based on search (UI).
- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker shouldIncludeUser:(id<FBGraphUser>)user
{
    if(self.searchText && ![self.searchText isEqualToString:@""])
    {
        NSRange result = [user.name rangeOfString:self.searchText options:NSCaseInsensitiveSearch];
        if (result.location != NSNotFound)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return YES;
    }
    return YES;
}
- (void)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                       handleError:(NSError *)error
{
    NSString *alertText;
    NSString *alertTitle;
    
    if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
        // Error requires people using you app to make an action outside your app to recover
        alertTitle = @"Lost connection";
        alertText = @"Please try again later";
       // [self showMessage:alertText withTitle:alertTitle];
        
    } else {
        // You need to find more information to handle the error within your app
        if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
            //The user refused to log in into your app, either ignore or...
            alertTitle = @"Login cancelled";
            alertText = @"You need to login to access this part of the app";
            //[self showMessage:alertText withTitle:alertTitle];
            
        } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
            // We need to handle session closures that happen outside of the app
            alertTitle = @"Session Error";
            alertText = @"Your current session is no longer valid. Please log in again.";
            //[self showMessage:alertText withTitle:alertTitle];
            
        } else {
            // All other errors that can happen need retries
            // Show the user a generic error message
            alertTitle = @"Lost Connection";
            alertText = @"Please try again later";
            //[self showMessage:alertText withTitle:alertTitle];
        }
    }
    [self dismissViewControllerAnimated:NO completion:^() {
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }];
}
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}
- (void)viewDidUnload {
    self.friendPickerController = nil;
    
    [super viewDidUnload];
}

@end
