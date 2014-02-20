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
@interface BFFMainPageViewController : UIViewController <FBLoginViewDelegate, UITableViewDelegate, UITableViewDataSource>
//called when this screen is unwinded to
- (IBAction)unwindToMain:(UIStoryboardSegue *) segue;
@end
