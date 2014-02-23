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
        
        [self.communicateButton setTitle:@"Yell!" forState:UIControlStateNormal];
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
        
        [self.communicateButton setTitle:@"Notify" forState:UIControlStateNormal];
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
        //share an open graph story using share dialog
    
        NSString* fullObjectName;
        NSString* objectName;
        if([[self.transactionToShow objectForKey:amountKey] integerValue]==1)
        {
            fullObjectName = @"borrowfromfriends: lent item";
            objectName = @"lent item";
        }
        else
        {
            fullObjectName = @"borrowfromfriends: lent items";
            objectName = @"lent items";
        }
        id<FBOpenGraphObject> object = [FBGraphObject openGraphObjectForPost];
        [object setType:fullObjectName];
        //this the variable in the "give me my <item> back" phrase
        [object setTitle:[self.transactionToShow objectForKey:itemNameKey]];
        [object setImage:@"http://i.imgur.com/g3Qc1HN.png" ];
        id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
        [action setObject:object forKey:objectName];
        [action setTags:@[[self.transactionToShow objectForKey:userIDKey]]];
        FBOpenGraphActionShareDialogParams *params = [[FBOpenGraphActionShareDialogParams alloc] init];
        params.action = action;
        params.actionType = @"borrowfromfriends:want";
        
        if([FBDialogs canPresentShareDialogWithOpenGraphActionParams:params]) {
            // Show the share dialog
            [FBDialogs presentShareDialogWithOpenGraphAction:action
                                                  actionType:@"borrowfromfriends:want"
                                         previewPropertyName:objectName
                                                     handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                         if(error) {
                                                             // There was an error
                                                             NSLog([NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                                         } else {
                                                             // Success
                                                             NSLog(@"result %@", results);
                                                         }
                                                     }];
            
            // If the Facebook app is NOT installed and we can't present the share dialog
        } else {
            // FALLBACK GOES HERE
        }
    
}
@end
