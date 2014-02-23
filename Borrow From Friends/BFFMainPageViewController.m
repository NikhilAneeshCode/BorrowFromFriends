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
    
    //recurrent notifcation
    //NSCalendar *calendar = [[NSCalendar alloc] init];
    //NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    NSDate *date = [[NSDate alloc] init];
    
    UILocalNotification *localNotfication = [[UILocalNotification alloc] init];
    if(localNotfication == nil)
    {
        return ;
    }
    int notificationTimeInterval = 3;
    localNotfication.fireDate = [date dateByAddingTimeInterval:60*60*24*notificationTimeInterval];
    localNotfication.timeZone = [NSTimeZone defaultTimeZone];
    NSString *alertMessage = [[NSString alloc] init];
    
    //THIS IS HOW YOU ACCESS THE ARRAY
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];//this is object you use to get the saved data
    NSMutableArray* array = [[defaults objectForKey:transactionArrayKey] mutableCopy];//this gets a mutable copy of the array of dictionaries(the transactionarraykey is a constant defined in Bffconstants.h
    //if(
    //localNotfication.alertBody = [NSString stringWithFormat:@""]
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
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    NSMutableArray* array = [[defaults objectForKey:transactionArrayKey] mutableCopy];
//    NSDictionary* user = [array objectAtIndex:indexPath.row];
//    UITextView *cellText =[[UITextView alloc] init];
//    [cellText setAttributedText:[self getCellTitle:user]];
//    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
//    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
//    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
//    [cellText boundingRectWithSize:labelSize options:NSStringDrawingTruncatesLastVisibleLine attributes:nil contex]
//    
//    return labelSize.height + 20;
//}



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
