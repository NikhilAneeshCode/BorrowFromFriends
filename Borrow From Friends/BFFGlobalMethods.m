//
//  BFFGlobalMethods.m
//  Borrow From Friends
//
//  Created by Aneesh Sachdeva on 2/26/14.
//  Copyright (c) 2014 Nikhil and Aneesh. All rights reserved.
//

#import "BFFGlobalMethods.h"
#import "BFFConstants.h"

@interface BFFGlobalMethods ()

@end

@implementation BFFGlobalMethods

/*- (void)createTestNotification
{
    [self deleteAllNotifications];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];//this is object you use to get the saved data
    NSMutableArray* items = [[defaults objectForKey:transactionArrayKey] mutableCopy];//this gets a mutable copy of the array of dictionaries(the transactionarraykey is a constant defined in Bffconstants.h
    
    int notificationRepeatInvervalDays = 3;
    
    //TODO MAKE IT SO IF THE ITEM COUNT IS NIL OR 0 (ELSE AT THE END OF THIS) UNSCHEDULE THE NOTIFICATIONS
    if(items != nil && items.count != 0)
    {
        NSDate *date = [[NSDate alloc] init];
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        
        if(localNotification == nil)
        {
            return ; // Apple said to do this
        }
        
        localNotification.fireDate = [date dateByAddingTimeInterval:12]; //comment this code out
        localNotification.repeatInterval = NSMinuteCalendarUnit; //comment this code out in final
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        
        localNotification.alertBody = @"Hello";
        localNotification.alertAction = NSLocalizedString(@"View Details", nil);
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber = 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
}*/

+ (void)updateNotifications
{
    //[[UIApplication sharedApplication] cancelAllLocalNotifications]; // clear all local notifications, start from fresh
    [self deleteAllNotifications];
    
    //THIS IS HOW YOU ACCESS THE ARRAY
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];//this is object you use to get the saved data
    NSMutableArray* items = [[defaults objectForKey:transactionArrayKey] mutableCopy];//this gets a mutable copy of the array of dictionaries(the transactionarraykey is a constant defined in Bffconstants.h
    
    int notificationRepeatInvervalDays = 3;
    
    if(items != nil && items.count != 0)
    {
        //first count the amount of lent and borrowed items
        int borrowedItemsCount = 0;
        int lentItemsCount = 0;
        
        for(int i = 0; i < items.count; i++)
        {
            if([[items[i] objectForKey:isLentKey] boolValue])
            {
                lentItemsCount++;
            }
            else
            {
                borrowedItemsCount++;
            }
        }
        
        //create the notification object
        NSDate *date = [[NSDate alloc] init];
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        
        if(localNotification == nil)
        {
            return ; // Apple said to do this
        }
        
        //localNotfication.fireDate = [date dateByAddingTimeInterval:60*60*24*notificationTimeInterval]; live code
        localNotification.fireDate = [date dateByAddingTimeInterval:30]; //comment this code out
        //localNotification.repeatInterval = NSDayCalendarUnit*notificationRepeatInvervalDays; live code
        localNotification.repeatInterval = NSMinuteCalendarUnit; //comment this code out in final
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        NSString *alertMessage = [[NSString alloc] init];
        
        if(items.count == 1)
        {
            if(lentItemsCount > 0)
            {
                alertMessage = @"Your friend still has an item of yours!";
            }
            else
            {
                alertMessage = @"You still have your friend's item!";
            }
        }
        else
        {
            if (lentItemsCount == 1 && borrowedItemsCount == 1)
                alertMessage = @"You still have your friend's item, and a friend still has an item of yours!";
            else if (lentItemsCount > 1 && borrowedItemsCount == 1)
                alertMessage = [NSString stringWithFormat:@"You still have your friend's item, and your friends still have %d items of yours!", lentItemsCount];
            else if (lentItemsCount > 1 && borrowedItemsCount > 1)
                alertMessage = [NSString stringWithFormat:@"You still have %d of your friends' items, and your friends still have %d items of yours!", borrowedItemsCount, lentItemsCount];
            else if (lentItemsCount == 1 && borrowedItemsCount > 1)
                alertMessage = [NSString stringWithFormat:@"You still have %d of your friends' items, and a friend still has an item of yours!", borrowedItemsCount];
            else if (lentItemsCount > 1 && borrowedItemsCount == 0)
                alertMessage = [NSString stringWithFormat:@"Your friends still have %d items of yours!", lentItemsCount];
            else if (lentItemsCount == 0 && borrowedItemsCount > 1)
                alertMessage = [NSString stringWithFormat:@"You still have %d of your friends' items!", borrowedItemsCount];
            else
            {
                // why can't grammar do itself. based god help me.
            }
            
        }
        
        localNotification.alertBody = alertMessage;
        localNotification.alertAction = NSLocalizedString(@"View Details", nil);
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber = 1;
        
        //save the notification to NSUserDefaults
        /*NSData *notificationData = [NSKeyedArchiver archivedDataWithRootObject:localNotification];
         if(notificationData != nil)
         {
         [[NSUserDefaults standardUserDefaults] setObject:notificationData forKey:repeatNotificationKey];
         [[NSUserDefaults standardUserDefaults] synchronize]; //CHECK
         }*/
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification]; //schedule the notification
    }
    else
    {
        // there are no items. make no notification
        //delete the notification object
        /*NSData *notificationData = [[NSUserDefaults standardUserDefaults] objectForKey:repeatNotificationKey];
         
         if(notificationData != nil)
         {
         UILocalNotification *notification = [NSKeyedUnarchiver unarchiveObjectWithData:notificationData];
         [[UIApplication sharedApplication] cancelLocalNotification:notification];
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:repeatNotificationKey];
         [[NSUserDefaults standardUserDefaults] synchronize]; //CHECK
         }*/
        
        //[[UIApplication sharedApplication] cancelAllLocalNotifications];
        [self deleteAllNotifications];
    }
    
}

+ (void)deleteAllNotifications
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


/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}*/

@end
