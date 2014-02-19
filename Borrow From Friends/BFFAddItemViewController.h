//
//  BFFAddItemViewController.h
//  Borrow From Friends
//
//  Created by Nikhil Khanna on 2/16/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Toast.h"

@interface BFFAddItemViewController : UIViewController <FBFriendPickerDelegate>
@property(nonatomic) BOOL lent;
@property(nonatomic) NSNumber *amount;
@property(nonatomic) NSString *name;
- (IBAction)valueChanged:(UIStepper *)sender;
- (IBAction)unwindToAddItem:(UIStoryboardSegue *) segue;
- (IBAction)pickFriendsButtonClick:(id)sender;
@end
