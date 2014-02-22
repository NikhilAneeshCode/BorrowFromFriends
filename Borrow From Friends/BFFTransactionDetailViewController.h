//
//  BFFTransactionDetailViewController.h
//  Borrow From Friends
//
//  Created by Nikhil Khanna on 2/20/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFFConstants.h"
#import "BFFMainPageViewController.h"
#import <FacebookSDK/FacebookSDK.h>
@interface BFFTransactionDetailViewController : UIViewController
//upon the controller being loaded, this should have the details of the transaction
@property(nonatomic) NSDictionary* transactionToShow;
@property(nonatomic) NSInteger transactionIndex;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *communicateButton;
-(IBAction)deleteTransaction:(id)sender;
-(IBAction)postToWall:(id)sender;
@end
