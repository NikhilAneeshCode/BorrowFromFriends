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
#import "BFFConstants.h"
#import "Appirater.h"
@interface BFFAddItemViewController : UIViewController <FBFriendPickerDelegate>
@property(nonatomic) BOOL lent;
@property(nonatomic) NSNumber *amount;
@property(nonatomic) NSString *name;

// search bar properties
@property(retain, nonatomic) FBFriendPickerViewController *friendPickerController; // store private friendPicker instance
@property(retain, nonatomic) UISearchBar *searchBar;
@property(retain, nonatomic) NSString *searchText;

- (IBAction)valueChanged:(UIStepper *)sender;
- (IBAction)pickFriendsButtonClick:(id)sender;
@end
