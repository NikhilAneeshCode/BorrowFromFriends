//
//  BFFLoginViewController.h
//  Borrow From Friends
//
//  Created by Nikhil Khanna on 2/11/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "BFFConstants.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"
#import "GAIFields.h"
@interface BFFLoginViewController : UIViewController <FBLoginViewDelegate>
- (IBAction)unwindToLogin:(UIStoryboardSegue *) segue;
@end
