//
//  BFFTransactionDetailViewController.h
//  Borrow From Friends
//
//  Created by Nikhil Khanna on 2/20/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFFConstants.h"
@interface BFFTransactionDetailViewController : UIViewController
//upon the controller being loaded, this should have the details of the transaction
@property(nonatomic) NSDictionary* transactionToShow;
@end
