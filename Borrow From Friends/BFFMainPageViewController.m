//
//  BFFTestViewController.m
//  Borrow From Friends
//
//  Created by Nikhil Khanna on 2/11/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import "BFFMainPageViewController.h"

@interface BFFMainPageViewController ()

@property (weak, nonatomic) IBOutlet UITableView *transactionTable;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation BFFMainPageViewController

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
    FBRequest* meRequest = [FBRequest requestForMe];
    [meRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSDictionary<FBGraphUser>* user = result;
        self.title = [NSString stringWithFormat:@"Welcome, %@", user.first_name];
    }];
    [self fillTransactionTable];
	// Do any additional setup after loading the view.
    
    //[self createNotification];
    
}


- (void)createNotification
{
    //THIS IS HOW YOU ACCESS THE ARRAY
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];//this is object you use to get the saved data
    NSMutableArray* items = [[defaults objectForKey:transactionArrayKey] mutableCopy];//this gets a mutable copy of the array of dictionaries(the transactionarraykey is a constant defined in Bffconstants.h
    
    int notificationRepeatInvervalDays = 3;
    
    //TODO MAKE IT SO IF THE ITEM COUNT IS NIL OR 0 (ELSE AT THE END OF THIS) UNSCHEDULE THE NOTIFICATIONS
    if(items != nil || items.count != 0)
    {
        //first count the amount of lent and borrowed items
        int borrowedItemsCount = 0;
        int lentItemsCount = 0;
        
        for(int i = 0; i < items.count; i++)
        {
            if([[items[i] objectForKey:isLentKey] boolValue])
            {
                lentItemsCount++;
            }
            else
            {
                borrowedItemsCount++;
            }
        }
        
        //create the notification object
        NSDate *date = [[NSDate alloc] init];
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        
        if(localNotification == nil)
        {
            return ; // Apple said to do this
        }
        
        //localNotfication.fireDate = [date dateByAddingTimeInterval:60*60*24*notificationTimeInterval]; live code
        localNotification.fireDate = [date dateByAddingTimeInterval:30]; //comment this code out
        //localNotification.repeatInterval = NSDayCalendarUnit*notificationRepeatInvervalDays; live code
        localNotification.repeatInterval = 30; //comment this code out in final
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        NSString *alertMessage = [[NSString alloc] init];
        
        if(items.count == 1)
        {
            if(lentItemsCount > 0)
            {
                alertMessage = @"Your friend still has an item of yours!";
            }
            else
            {
                alertMessage = @"You still have your friend's item!";
            }
        }
        else
        {
            if (lentItemsCount == 1 && borrowedItemsCount == 1)
                alertMessage = @"You still have your friend's item, and a friend still has an item of yours!";
            else if (lentItemsCount > 1 && borrowedItemsCount == 1)
                alertMessage = [NSString stringWithFormat:@"You still have your friend's item, and your friends still have %d items of yours!", lentItemsCount];
            else if (lentItemsCount > 1 && borrowedItemsCount > 1)
                alertMessage = [NSString stringWithFormat:@"You still have %d of your friends' items, and your friends still have %d items of yours!", borrowedItemsCount, lentItemsCount];
            else if (lentItemsCount == 1 && borrowedItemsCount > 1)
                alertMessage = [NSString stringWithFormat:@"You still have %d of your friends' items, and a friend still has an item of yours!", borrowedItemsCount];
            else if (lentItemsCount > 1 && borrowedItemsCount == 0)
                alertMessage = [NSString stringWithFormat:@"Your friends still have %d items of yours!", lentItemsCount];
            else if (lentItemsCount == 0 && borrowedItemsCount > 1)
                alertMessage = [NSString stringWithFormat:@"You still have %d of your friends' items!", borrowedItemsCount];
            else
            {
                // why can't grammar do itself. based god help me.
            }
            
        }
        
        localNotification.alertBody = alertMessage;
        localNotification.alertAction = NSLocalizedString(@"View Details", nil);
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    else
    {
        // there are no items. make no notification
        //TO DO UNSCHEDULE NOTIFICATION
    }

}

/*//called if login button pressed, handles logging out and sending to login screen
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}*/


//called when this screen is unwinded to
-(IBAction)unwindToMain:(UIStoryboardSegue *)segue
{
    //refill transaction table incase of any changes
    [self fillTransactionTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//called when transaction table needs to be filled
-(void)fillTransactionTable
{
    //defaults stores an array of dictionaries, each dictionary representing a single transaction
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:transactionArrayKey]==nil)
    {
        //to do handle empty array an
        [self.transactionTable reloadData];
        return;
    }
    //simply reloads the data for the
    [self.transactionTable reloadData];
    
    [self createNotification];
}

//table view delgate method to show number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//delegate method for number of rows in table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:transactionArrayKey] count];
}

//delegate method to generate each cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //getting a new cell (or existing one if possible)
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* array = [[defaults objectForKey:transactionArrayKey] mutableCopy];
    NSDictionary* user = [array objectAtIndex:indexPath.row];
    
    //gets profile data and assigns it to the picture
    UIImage *profilePic = [[UIImage alloc] initWithData:[user objectForKey:profilePictureDataKey]];
    //assigning properties of the cells

    NSString* cellTitle;
    cellTitle = [self getCellTitle:user];
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    cell.textLabel.text = cellTitle;
    cell.imageView.image = profilePic;
    //setting cell colors
    if([[user objectForKey:isLentKey] boolValue])
    {
        cell.contentView.backgroundColor = [UIColor orangeColor];
    }
    else
    {
        cell.contentView.backgroundColor = [UIColor blueColor];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

    return cell;
}
- (NSString *) getCellTitle: (NSDictionary*) user
{
    if([[user objectForKey:isLentKey] boolValue])
    {
        if([[user objectForKey:amountKey] integerValue]==1)
        {
            return [NSString stringWithFormat:@"%@ still has your %@", [user objectForKey:userFirstKey], [user objectForKey:itemNameKey]];
        }
        else
        {
            return [NSString stringWithFormat:@"%@ still has your %d %@", [user objectForKey:userFirstKey], [[user objectForKey:amountKey] integerValue],[user objectForKey:itemNameKey]];
        }
    }
    else
    {
        if([[user objectForKey:amountKey] integerValue]==1)
        {
            return [NSString stringWithFormat:@"You still have %@'s %@", [user objectForKey:userFirstKey], [user objectForKey:itemNameKey]];
        }
        else
        {
            return [NSString stringWithFormat:@"You still have %@'s %d %@", [user objectForKey:userFirstKey], [[user objectForKey:amountKey] integerValue],[user objectForKey:itemNameKey]];
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* array = [[defaults objectForKey:transactionArrayKey] mutableCopy];
    NSDictionary* user = [array objectAtIndex:indexPath.row];
    NSString *content = [self getCellTitle:user];
    
    // Max size you will permit
    CGSize maxSize = CGSizeMake(200, 1000);
    CGSize size = [content sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17] constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    return size.height + 2*20;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}
//delegate method for the disclousre button being tapped on a cell
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //sets the linked user to a class property
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* array = [[defaults objectForKey:transactionArrayKey] mutableCopy];
    self.selectedTransaction = [array objectAtIndex:indexPath.row];
    self.transactionIndex = indexPath.row;
    [self performSegueWithIdentifier:@"transactionDetailSegue" sender:self];
}

//called when a segue is triggered used to assign values to transaction screen
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"transactionDetailSegue"])
    {
        BFFTransactionDetailViewController* transactionView = segue.destinationViewController;
        transactionView.transactionToShow = self.selectedTransaction;
        transactionView.transactionIndex = self.transactionIndex;
    }
}
@end
