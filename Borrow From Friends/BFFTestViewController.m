//
//  BFFTestViewController.m
//  Borrow From Friends
//
//  Created by Nikhil Khanna on 2/11/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import "BFFTestViewController.h"

@interface BFFTestViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation BFFTestViewController

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
        self.nameLabel.text = user.name;
    }];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
