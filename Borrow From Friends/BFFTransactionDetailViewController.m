//
//  BFFTransactionDetailViewController.m
//  Borrow From Friends
//
//  Created by Nikhil Khanna on 2/20/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import "BFFTransactionDetailViewController.h"

@interface BFFTransactionDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePic;
@property (weak, nonatomic) IBOutlet UIButton *FBMessageButton;

@end

@implementation BFFTransactionDetailViewController

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
    //setting the label based on lent/borrowed and the item amount
    NSString* stringToShow;
    NSNumber* isLent = [self.transactionToShow objectForKey:isLentKey];
    NSNumber* itemAmount = [self.transactionToShow objectForKey:amountKey];
    [isLent boolValue];
    if([isLent boolValue])
    {
        if([itemAmount intValue] == 1)
        {
            stringToShow = [NSString stringWithFormat:@"%@ still has your %@",[self.transactionToShow objectForKey:userFirstKey], [self.transactionToShow objectForKey:itemNameKey] ];
        }
        else
        {
            stringToShow = [NSString stringWithFormat:@"%@ still has %d of your %@",[self.transactionToShow objectForKey:userFirstKey], [[self.transactionToShow objectForKey:amountKey] intValue], [self.transactionToShow objectForKey:itemNameKey] ];
        }
    }
    else
    {
        if([itemAmount intValue] == 1)
        {
            stringToShow = [NSString stringWithFormat:@"You still have %@'s %@",[self.transactionToShow objectForKey:userFirstKey], [self.transactionToShow objectForKey:itemNameKey] ];
        }
        else
        {
            stringToShow = [NSString stringWithFormat:@"You still have %d of %@'s  %@",[[self.transactionToShow objectForKey:amountKey] intValue], [self.transactionToShow objectForKey:userFirstKey], [self.transactionToShow objectForKey:itemNameKey] ];
        }
    }
    //TODO: We need to ensure that the text lable will expand vertically if it's going to get cut off by the edge of the screen.
    self.textLabel.text = stringToShow;
    self.profilePic.profileID = [self.transactionToShow objectForKey:userIDKey];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)deleteTransaction:(id)sender
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* transactionArray = [[defaults objectForKey:transactionArrayKey] mutableCopy];
    [transactionArray removeObjectAtIndex:self.transactionIndex];
    [defaults setObject:transactionArray forKey:transactionArrayKey];
    [defaults synchronize];
    //kinda hackish but basiceally tells the main view controller to reload the transaction table
    [[[self.navigationController childViewControllers] firstObject] fillTransactionTable];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)postToWall:(id)sender
{
    //if app installed
    if([FBDialogs canPresentOSIntegratedShareDialogWithSession:nil])
    {
       //TODO present via share dialog
    }
    else //presenting via feeds
    {
        //fill this with the appropriate parameters for each event (borrowed/lended and # of objects)
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Sharing Tutorial", @"name",
                                       @"Build great social apps and get more installs.", @"caption",
                                       @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
                                       @"http://i.imgur.com/g3Qc1HN.png", @"picture",
                                       [self.transactionToShow objectForKey:userIDKey], @"friends",
                                       nil];
        
        
        [FBWebDialogs presentFeedDialogModallyWithSession:[FBSession activeSession] parameters:params handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
            if (error) {
                // An error occurred, we need to handle the error
                // See: https://developers.facebook.com/docs/ios/errors
                NSLog([NSString stringWithFormat:@"Error publishing story: %@", error.description]);
            } else {
                if (result == FBWebDialogResultDialogNotCompleted) {
                    // User cancelled.
                    NSLog(@"User cancelled.");
                } else {
                    // Handle the publish feed callback
                    }
            }
        }];
    }
    
}
@end
