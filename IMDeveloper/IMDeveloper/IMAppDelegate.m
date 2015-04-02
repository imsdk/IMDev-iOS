//
//  IMAppDelegate.m
//  IMDeveloper
//
//  Created by mac on 14-12-9.
//  Copyright (c) 2014年 IMSDK. All rights reserved.
//

/**
 appKey = @"d3fecc6841c022fc7b7021dd"
 */
#import "IMAppDelegate.h"
#import "IMRootViewController.h"
#import "IMLoginViewController.h"
#import "IMDefine.h"

//IMSDK Headers
#import "IMSDK.h"
#import "IMMyself.h"

@implementation IMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [g_pIMSDK initWithAppKey:IMDeveloper_APPKey];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    IMLoginViewController *controller = [[IMLoginViewController alloc] init] ;
        
    [[self window] setRootViewController:controller];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
    {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
            [[UIApplication sharedApplication] performSelector:@selector(registerForRemoteNotifications) withObject:nil];
        }
        
        UIUserNotificationType types = UIUserNotificationTypeBadge                                                                                                                      | UIUserNotificationTypeSound | UIUserNotificationTypeAlert ;
        
        UIUserNotificationSettings * setting =  [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
         
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
    
    return YES;
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
    
    [g_pIMSDK applicationDidEnterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [g_pIMSDK applicationWillEnterForeground];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [g_pIMSDK setDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"failed to register for remote notifications with error: %@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
}
@end
