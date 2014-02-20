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
    [isLent boolValue];
    if([isLent boolValue])
    {
        stringToShow = [NSString stringWithFormat:@"%@ still has your %d %@",[self.transactionToShow objectForKey:userFirstKey], [[self.transactionToShow objectForKey:amountKey] intValue], [self.transactionToShow objectForKey:itemNameKey] ];
    }
    else
    {
        stringToShow = [NSString stringWithFormat:@"You still have %@'s %d %@",[self.transactionToShow objectForKey:userFirstKey], [[self.transactionToShow objectForKey:amountKey] intValue], [self.transactionToShow objectForKey:itemNameKey] ];
    }
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
    [[[self.navigationController childViewControllers] firstObject] fillTransactionTable];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
