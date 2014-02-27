//
//  BFFTestViewController.m
//  Borrow From Friends
//
//  Created by Nikhil Khanna on 2/11/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import "BFFMainPageViewController.h"
#import "BFFGlobalMethods.h"

@interface BFFMainPageViewController ()

@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;
@property (weak, nonatomic) IBOutlet UITableView *transactionTable;
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
    NSString* userFirst = [[NSUserDefaults standardUserDefaults]objectForKey:currentUserKey];
    self.title = [NSString stringWithFormat:@"Welcome, %@", userFirst];
    [self fillTransactionTable];
	// Do any additional setup after loading the view.
}



/*//called if login button pressed, handles logging out and sending to login screen
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}*/


//called when this screen is unwinded to
- (IBAction)unwindToMain:(UIStoryboardSegue *)segue
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
    [BFFGlobalMethods updateNotifications];
    
    //defaults stores an array of dictionaries, each dictionary representing a single transaction
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:transactionArrayKey]==nil)
    {
        //to do handle empty array an
        [self.transactionTable reloadData];
        [self.transactionTable setHidden:TRUE];
        [self.emptyLabel setHidden:FALSE];
        return;
    }
    [self.emptyLabel setHidden:TRUE];
    [self.transactionTable setHidden:FALSE];
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
    
    //setting cell colors put final cell colors here (you can use rgb values as well via the UIColor colorwithRedMethod
    //UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    UIImage *buttonImage = [[UIImage alloc] init];
    
    if([[user objectForKey:isLentKey] boolValue])
    {
        //cell.contentView.backgroundColor = [UIColor orangeColor]; this is the old code, don't use
        
        //backgroundView.backgroundColor = [UIColor colorWithRed:(78.0/255.0) green:(98.0/255.0) blue:(250.0/255.0) alpha:0.05]; //blue/purple
        //backgroundView.backgroundColor = [UIColor colorWithRed:(255.0/255.0) green:(50.0/255.0) blue:(0.0/255.0) alpha:0.1]; //orange
        //[[UIColor colorWithRed:(78.0/255.0) green:(98.0/255.0) blue:(250.0/255.0) alpha:0.05] get
        
        buttonImage = [UIImage imageNamed:@"orange_accessory_button.png"];
    }
    else
    {
        //cell.contentView.backgroundColor = [UIColor blueColor]; this is the old code, don't use
        //backgroundView.backgroundColor = [UIColor colorWithRed:(71.0/255.0) green:(250.0/255.0) blue:(55.0/255.0) alpha:0.1]; //green
        //backgroundView.backgroundColor = [UIColor colorWithRed:(0.0/255.0) green:(76.0/255.0) blue:(200.0/255.0) alpha:0.1]; //blue
        //backgroundView.backgroundColor = [UIColor colorWithRed:(255.0/255.0) green:(50.0/255.0) blue:(0.0/255.0) alpha:0.03]; //orange
        
        buttonImage = [UIImage imageNamed:@"blue_accessory_button.png"];
    }
    
    //cell.backgroundView = backgroundView;
    
    //add/remove accessory button
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    UIImageView *buttonView = [[UIImageView alloc] initWithImage:buttonImage];
    [cell setAccessoryView:buttonView];

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
