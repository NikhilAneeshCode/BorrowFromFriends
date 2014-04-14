//
//  BFFSettingsPageViewController.m
//  Borrow From Friends
//
//  Created by Aneesh Sachdeva on 2/22/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import "BFFSettingsPageViewController.h"
#import "BFFLoginViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"
#import "GAIFields.h"
@interface BFFSettingsPageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *deleteAllButton;

@end

@implementation BFFSettingsPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Settings"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.deleteAllButton setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
    [[self.deleteAllButton layer] setCornerRadius:5.0f];
    //[[self.deleteAllButton layer] setBorderWidth:1.0f];
	// Do any additional setup after loading the view.
}

//called if login button pressed, handles logging out and sending to login screen
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:@"Settings"];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Logout"
                                                          action:[NSString stringWithFormat:@"%@ logout", [[NSUserDefaults standardUserDefaults] objectForKey:currentUserIdKey]]
                                                           label:@"user has been logged out"
                                                           value:nil] build]];
    [tracker set:kGAIScreenName value:nil];
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

-(IBAction)deleteAllData:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"This will delete all of your items!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes I am sure", nil];
    
    [alert show];
}

//alert view delegate method. handles buttons clicks
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //if "I'm sure" is clicked
    if(buttonIndex != [alertView cancelButtonIndex])
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:transactionArrayKey];
        [defaults synchronize];
        //kinda hackish but basiceally tells the main view controller to reload the transaction table
        [[[self.navigationController childViewControllers] firstObject] fillTransactionTable];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
