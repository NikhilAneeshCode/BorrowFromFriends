//
//  BFFSettingsPageViewController.h
//  Borrow From Friends
//
//  Created by Aneesh Sachdeva on 2/22/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "BFFConstants.h"
#import "BFFMainPageViewController.h"
@interface BFFSettingsPageViewController : UIViewController <FBLoginViewDelegate>
-(IBAction)deleteAllData:(id)sender;
@end
