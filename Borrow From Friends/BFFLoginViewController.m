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

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    self.nameLabel.text = @"Please log in";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
