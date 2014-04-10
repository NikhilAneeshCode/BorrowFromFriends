//
//  BFFTransactionDetailViewController.m
//  Borrow From Friends
//
//  Created by Nikhil Khanna on 2/20/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import "BFFTransactionDetailViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"
#import "GAIFields.h"
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Transaction Detail"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //setting the label based on lent/borrowed and the item amount
    NSString* stringToShow;
    NSNumber* isLent = [self.transactionToShow objectForKey:isLentKey];
    NSNumber* itemAmount = [self.transactionToShow objectForKey:amountKey];
    if([isLent boolValue])
    {
        self.title = @"Lent Item";
        if([itemAmount intValue] == 1)
        {
            stringToShow = [NSString stringWithFormat:@"%@ still has your %@",[self.transactionToShow objectForKey:userFirstKey], [self.transactionToShow objectForKey:itemNameKey] ];
        }
        else
        {
            stringToShow = [NSString stringWithFormat:@"%@ still has %d of your %@",[self.transactionToShow objectForKey:userFirstKey], [[self.transactionToShow objectForKey:amountKey] intValue], [self.transactionToShow objectForKey:itemNameKey] ];
        }
        
        [self.communicateButton setTitle:@"Yell!" forState:UIControlStateNormal];
        [self.communicateButton setBackgroundColor:[UIColor colorWithRed:1 green:.5 blue:0 alpha:1]];
    }
    else
    {
        self.title = @"Borrowed Item";
        if([itemAmount intValue] == 1)
        {
            stringToShow = [NSString stringWithFormat:@"You still have %@'s %@",[self.transactionToShow objectForKey:userFirstKey], [self.transactionToShow objectForKey:itemNameKey] ];
        }
        else
        {
            stringToShow = [NSString stringWithFormat:@"You still have %d of %@'s  %@",[[self.transactionToShow objectForKey:amountKey] intValue], [self.transactionToShow objectForKey:userFirstKey], [self.transactionToShow objectForKey:itemNameKey] ];
        }
        
        [self.communicateButton setTitle:@"Notify" forState:UIControlStateNormal];
        [self.communicateButton setBackgroundColor:[UIColor colorWithRed:0 green:.5 blue:1 alpha:1]];

    }
    [[self.communicateButton layer] setCornerRadius:5.0f];
    [self.deleteButton setBackgroundColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:1]];
    [[self.deleteButton layer] setCornerRadius:5.0f];
    //TODO: We need to ensure that the text lable will expand vertically if it's going to get cut off by the edge of the screen.
    self.textLabel.numberOfLines = 0;
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
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
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:@"Transaction Detail"];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Delete Transaction"
                                                          action:[NSString stringWithFormat:@"%@ deleted", [[NSUserDefaults standardUserDefaults] objectForKey:currentUserIdKey]]
                                         label:[NSString stringWithFormat:@"friendid: %@, amount %d, itemname: %@", [self.transactionToShow objectForKey:userIDKey],[[self.transactionToShow objectForKey:amountKey] intValue],[self.transactionToShow objectForKey:itemNameKey]]
                                         value:nil] build]];
    [tracker set:kGAIScreenName value:nil];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* transactionArray = [[defaults objectForKey:transactionArrayKey] mutableCopy];
    [transactionArray removeObjectAtIndex:self.transactionIndex];
    if([transactionArray count]==0)
    {
        [defaults removeObjectForKey:transactionArrayKey];
    }
    else
    {
        [defaults setObject:transactionArray forKey:transactionArrayKey];
    }
    [defaults synchronize];
    //kinda hackish but basiceally tells the main view controller to reload the transaction table
    [[[self.navigationController childViewControllers] firstObject] fillTransactionTable];
    [self.navigationController popViewControllerAnimated:YES];
}







//The monolithic method for posting to a wall
-(IBAction)postToWall:(id)sender
{
    //log the wall post
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:@"Transaction Detail"];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Wall Post"
                                                          action:[NSString stringWithFormat:@"%@ posted", [[NSUserDefaults standardUserDefaults] objectForKey:currentUserIdKey]]
                                                           label:[NSString stringWithFormat:@"friendid: %@, amount %d, itemname: %@", [self.transactionToShow objectForKey:userIDKey],[[self.transactionToShow objectForKey:amountKey] intValue],[self.transactionToShow objectForKey:itemNameKey]]
                                                           value:nil] build]];
    [tracker set:kGAIScreenName value:nil];
        //share an open graph story using share dialog
    
        NSString* fullObjectName;
        NSString* objectName;
        NSString* fullActionName;
    
        //figuring out the open graph object and action name based on the specifics of the transaction
        if([[self.transactionToShow objectForKey:isLentKey] boolValue])
        {
            fullActionName = @"borrowfromfriends:want";
            fullObjectName = @"borrowfromfriends:lent item";
            objectName = @"lent item";
        }
        else
        {
            fullActionName = @"borrowfromfriends:has";
            fullObjectName = @"borrowfromfriends:borrowed item";
            objectName = @"borrowed item";
        }
        id<FBOpenGraphObject> object = [FBGraphObject openGraphObjectForPost];
        [object setType:fullObjectName];
        [object setProvisionedForPost:TRUE];
        //setting title,the variable in the "give me my <item> back" phrase
        NSString* description;
        if([[self.transactionToShow objectForKey:isLentKey] boolValue])
        {
            if([[self.transactionToShow objectForKey:amountKey] integerValue]==1)
            {
                description = [NSString stringWithFormat:@"%@ needs to give me my %@ back!", [self.transactionToShow objectForKey:userFirstKey], [self.transactionToShow objectForKey:itemNameKey]];
            }
            else
            {
                description = [NSString stringWithFormat:@"%@ needs to give me my %d %@ back!", [self.transactionToShow objectForKey:userFirstKey], [[self.transactionToShow objectForKey:amountKey] integerValue], [self.transactionToShow   objectForKey:itemNameKey]];
            }
        }
        else
        {
            if([[self.transactionToShow objectForKey:amountKey] integerValue]==1)
            {
                description = [NSString stringWithFormat:@"Hey %@, I still have your %@.", [self.transactionToShow objectForKey:userFirstKey], [self.transactionToShow objectForKey:itemNameKey]];
            }
            else
            {
                description = [NSString stringWithFormat:@"Hey %@, I still have your %d %@.", [self.transactionToShow objectForKey:userFirstKey], [[self.transactionToShow objectForKey:amountKey] integerValue], [self.transactionToShow   objectForKey:itemNameKey]];
            }
        }
        NSString* title;
        NSString* capsName = [[self.transactionToShow objectForKey:itemNameKey] capitalizedString];
        if([[self.transactionToShow objectForKey:amountKey] integerValue]==1)
        {
            title = capsName;
        }
        else
        {
            title = [NSString stringWithFormat:@"%d %@", [[self.transactionToShow objectForKey:amountKey] integerValue], capsName];
        }
        [object setTitle:title];
        [object setDescription:description];
        [object setImage:@"http://i.imgur.com/bgld4hX.png" ];
        id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
        [action setObject:object forKey:objectName];
        //sets action tags (might hack this in after submission lol)
        [action setTags:@[[self.transactionToShow objectForKey:userIDKey]]];
        NSDate* endDate = [NSDate dateWithTimeIntervalSinceNow:604800];
        [action setEnd_time:[endDate description]];
        FBOpenGraphActionShareDialogParams *params = [[FBOpenGraphActionShareDialogParams alloc] init];
        params.action = action;
        params.actionType = fullActionName;
        if([FBDialogs canPresentShareDialogWithOpenGraphActionParams:params]) {
            // Show the share dialog
            [FBDialogs presentShareDialogWithOpenGraphAction:action
                                                  actionType:fullActionName
                                         previewPropertyName:objectName
                                                     handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                         if(error) {
                                                             // There was an error
                                                             NSLog([NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                                         } else {
                                                             // Success
                                                             NSLog(@"result %@", results);
                                                             [Appirater userDidSignificantEvent:TRUE];
                                                         }
                                                     }];
            
            // If the Facebook app is NOT installed and we can't present the share dialog
        }
        else
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           title, @"name",
                                           @"http://i.imgur.com/bgld4hX.png", @"picture",
                                           nil];
            // Show the feed dialog
            [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                                   parameters:params
                                                      handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                          if (error) {
                                                              // Error launching the dialog or publishing a story.
                                                              NSLog([NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                                          } else {
                                                              if (result == FBWebDialogResultDialogNotCompleted) {
                                                                  // User cancelled.
                                                                  NSLog(@"User cancelled.");
                                                              } else {
                                                                  // Handle the publish feed callback
                                                                  NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                                  
                                                                  if (![urlParams valueForKey:@"post_id"]) {
                                                                      // User canceled.
                                                                      NSLog(@"User cancelled.");
                                                                      
                                                                  } else {
                                                                      // User clicked the Share button
                                                                      NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                      NSLog(@"result %@", result);
                                                                      [Appirater userDidSignificantEvent:TRUE];
                                                                  }
                                                              }
                                                          }
                                                      }];
        }
    
}
/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}
@end
