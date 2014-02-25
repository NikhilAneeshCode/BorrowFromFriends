//
//  BFFAppDelegate.m
//  Borrow From Friends
//
//  Created by Nikhil Khanna on 2/9/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import "BFFAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Appirater.h"
@implementation BFFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //place code here to add custom code after application launch
    //TO DO CALL APPIRATER DID SOMETHING SIGNIFICANT WHEN NECCESSARY
    //note about appirater: call [Appirater userDidSignificantEvent:YES] when the user does something significant
    [Appirater setAppId:@"558312836"];//temporary app id TODO SWITCH THIS TO REAL APP ID
    [Appirater setDaysUntilPrompt:1];
    [Appirater setUsesUntilPrompt:2];
    [Appirater setSignificantEventsUntilPrompt:3];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:YES];//temp debug code
    
    application.applicationIconBadgeNumber = 0;
    
    // forward declaring fb classes
    [FBLoginView class];
    [FBProfilePictureView class];
    [FBFriendPickerViewController class];
    
    //handle launching from a notification when app has not been opened (i.e not in foreground).
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if(localNotification)
    {
        application.applicationIconBadgeNumber = 0;
        //TODO: Check login session and open the main screen
    }
    
    //[application cancelAllLocalNotifications];
    [self deleteAllNotifications]; 
    
    return YES;
}

- (void)deleteAllNotifications
{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    if(notifications != nil)
    {
        for(int i = 0; i < notifications.count; i++)
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notifications[i]];
        }
    }
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // handle launching from a notification when app is either running or has been transitioned away from
    UIApplicationState state = [application applicationState];
    if(state == UIApplicationStateActive)
    {
        application.applicationIconBadgeNumber = 0;
        //do nothing else
    }
    if(state == UIApplicationStateInactive)
    {
        application.applicationIconBadgeNumber = 0;
        //TODO: Check login session and open the main screen
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [Appirater appEnteredForeground:YES];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//this method handles opening url response from facebook app
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call) {
        if([[call appLinkData] targetURL] != nil) {
            // get the object ID string from the deep link URL
            // we use the substringFromIndex so that we can delete the leading '/' from the targetURL
            NSString *objectId = [[[call appLinkData] targetURL].path substringFromIndex:1];
            
            // now handle the deep link
            // write whatever code you need to show a view controller that displays the object, etc.
        } else {
            //
            NSLog([NSString stringWithFormat:@"Unhandled deep link: %@", [[call appLinkData] targetURL]]);
        }
    }];
    
    return wasHandled;
}

@end
