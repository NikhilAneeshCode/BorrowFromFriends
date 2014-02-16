//
//  BFFTestViewController.h
//  Borrow From Friends
//
//  Created by Nikhil Khanna on 2/11/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface BFFMainPageViewController : UIViewController <FBLoginViewDelegate>
- (IBAction)unwindToMain:(UIStoryboardSegue *) segue;
@end
