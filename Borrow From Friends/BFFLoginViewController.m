//
//  BFFLoginViewController.m
//  Borrow From Friends
//
//  Created by Nikhil Khanna on 2/11/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import "BFFLoginViewController.h"

@interface BFFLoginViewController ()
@property (weak, nonatomic) IBOutlet FBLoginView *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendLabel;

@end

@implementation BFFLoginViewController

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
    self.loginButton.readPermissions = @[@"basic_info"];
	// Do any additional setup after loading the view.
}


//
// LOGIN BUTTON DELEGATE METHODS
//

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    self.nameLabel.text = [NSString stringWithFormat:@"Logged in as %@", user.name];
}
//Called when it enters loggedin mode
-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    FBRequest *friendsRequest = [FBRequest requestForMyFriends];
    //async method where callback handles the friend data
    [friendsRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSArray* friends = [result objectForKey:@"data"];
        NSDictionary<FBGraphUser>* firstFriend = [friends objectAtIndex:0];
        self.friendLabel.text = firstFriend.name;
    }];
}
//Called when enter loggedout mode
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    self.nameLabel.text = @"Please log in";
}


// TODO: check this block of code and handle other possible errors
// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
