//
//  BFFFriendPickerViewController.h
//  Borrow From Friends
//
//  Created by Nikhil Khanna on 2/16/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface BFFFriendPickerViewController : UIViewController
@property(nonatomic) BOOL *lent;
@property(nonatomic) NSInteger *amount;
@property(nonatomic) NSString *name;
@end
