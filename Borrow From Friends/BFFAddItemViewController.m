//
//  BFFAddItemViewController.m
//  Borrow From Friends
//
//  Created by Nikhil Khanna on 2/16/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import "BFFAddItemViewController.h"

@interface BFFAddItemViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIStepper *amountStepper;
@property (weak, nonatomic) IBOutlet UILabel *amountField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *borrowedSwitch;
@end

@implementation BFFAddItemViewController

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
	// Do any additional setup after loading the view.
}

//called when a segue occurs
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //making it so all information is passed from buttons on this page to properties in friend picker
    if ([segue.identifier isEqualToString:@"friendSegue"]) {
        UINavigationController *navController =(UINavigationController *)segue.destinationViewController;
        BFFFriendPickerViewController *friendController = (BFFFriendPickerViewController *)navController.topViewController;
        friendController.name = self.nameField.text;
        friendController.amount = [NSNumber numberWithInt:(int)self.amountStepper.value];
        //if its the first segment (i.e. lent it) set it to true else it'll be false
        friendController.lent = self.borrowedSwitch.selectedSegmentIndex == 0;
    }
}

-(void)dismissKeyboard
{
    [self.nameField resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//called when the stepper changes value
- (IBAction)valueChanged:(UIStepper *)sender
{
    self.amountField.text = [NSString stringWithFormat:@"%d", (int)sender.value];
}
@end
