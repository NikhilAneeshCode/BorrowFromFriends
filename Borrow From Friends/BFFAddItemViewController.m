//
//  BFFAddItemViewController.m
//  Borrow From Friends
//
//  Created by Nikhil Khanna on 2/16/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import "BFFAddItemViewController.h"

@interface BFFAddItemViewController () <FBFriendPickerDelegate, UISearchBarDelegate>
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
//if submit is hit takes you to friendpicker page
- (IBAction)pickFriendsButtonClick:(id)sender
{
    self.name = self.nameField.text;
    self.amount = [NSNumber numberWithInt:(int)self.amountStepper.value];
    //if its the first segment (i.e. lent it) set it to true else it'll be false
    self.lent = self.borrowedSwitch.selectedSegmentIndex == 0;
    [self loadFriendPicker];
}
- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
//called when the stepper changes value
- (IBAction)valueChanged:(UIStepper *)sender
{
    self.amountField.text = [NSString stringWithFormat:@"%d", (int)sender.value];
}

//called when friend picker done is pressed
- (void)facebookViewControllerDoneWasPressed:(id)sender
{
    //no one selected show the toast
    if(self.friendPickerController.selection.count==0)
    {
        Toast* t = [Toast toastWithMessage:@"Please select a friend"];
        [t showOnView:self.friendPickerController.view];
        return;
    }
    
    id<FBGraphUser> user = self.friendPickerController.selection.firstObject;
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
    
    [self dismissViewControllerAnimated:YES completion:^() {
        [self performSegueWithIdentifier:@"mainSegue" sender:self];
    }];
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

- (void)viewDidUnload {
    self.friendPickerController = nil;
    
    [super viewDidUnload];
}

@end
