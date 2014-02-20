//
//  BFFTestViewController.h
//  Borrow From Friends
//
//  Created by Nikhil Khanna on 2/11/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "BFFConstants.h"
#import "BFFTransactionDetailViewController.h"
@interface BFFMainPageViewController : UIViewController <FBLoginViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property(nonatomic) NSDictionary* selectedTransaction;
@property(nonatomic) NSInteger transactionIndex;
//called when this screen is unwinded to
- (IBAction)unwindToMain:(UIStoryboardSegue *) segue;
//called when table needs to be filled or reloaded
-(void)fillTransactionTable;
@end
