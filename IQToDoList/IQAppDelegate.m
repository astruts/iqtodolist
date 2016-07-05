//
//  IQAppDelegate.m
//  IQToDoList
//
//  Created by Admin on 6/22/16.
//  Copyright (c) 2016 Admin. All rights reserved.
//

#import "IQAppDelegate.h"
#import "IQCoreDataManager.h"

@implementation IQAppDelegate

static NSString *const NotificationAlertTitle = @"Reminder";
static NSString *const NotificationAlertCancelButtonTitle = @"OK";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IQCoreDataManager instance];
    
    [self preloadKeyboard];
    
    [self retreiveStoredNotifications:launchOptions];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Saves changes in the application's managed object context before the application terminates.
    [[IQCoreDataManager instance] saveContext];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NotificationAlertTitle
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:NotificationAlertCancelButtonTitle
                                              otherButtonTitles:nil];
        [alert show];
        application.applicationIconBadgeNumber--;
    }
}

#pragma mark - Private methods

- (void)preloadKeyboard {
    // Preloads keyboard so there's no lag on initial keyboard appearance.
    UITextField *lagFreeField = [[UITextField alloc] init];
    [self.window addSubview:lagFreeField];
    [lagFreeField becomeFirstResponder];
    [lagFreeField resignFirstResponder];
    [lagFreeField removeFromSuperview];
}

- (void)retreiveStoredNotifications:(NSDictionary *)launchOptions {
    //  Handle launching from a notification
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        // Set icon badge number to zero
        [self application:[UIApplication sharedApplication] didReceiveLocalNotification:localNotification];
        //application.applicationIconBadgeNumber = 0;
    }
}

@end
