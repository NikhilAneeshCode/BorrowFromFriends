//
//  BFFFriendPickerViewController.m
//  Borrow From Friends
//
//  Created by Nikhil Khanna on 2/16/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import "BFFFriendPickerViewController.h"

@interface BFFFriendPickerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation BFFFriendPickerViewController

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
    if(self.lent)
    {
        self.titleLabel.text = @"Who did you lend to?";
	}
    else
    {
        self.titleLabel.text = @"Who did you borrow from";
    }
        // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
