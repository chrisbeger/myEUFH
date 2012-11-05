//
//  AppDelegate.m
//  myEUFH
//
//  Created by Christoph Beger on 18.10.12.
//  Copyright (c) 2012 Christoph Beger. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //[[UINavigationBar appearance] setBackgroundColor:[[UIColor alloc] initWithRed:244 green:158 blue:0 alpha:0.5]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:244/255.0 green:157/255.0 blue:0/255.0 alpha:1.0]];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
    
    NSLog(@"Registering Remote Notications");

    
    return YES;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	NSLog(@"devToken=%@",deviceToken);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
	NSLog(@"Error in registration. Error: %@", err);
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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSUserDefaults *defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"myeufh_remember"] integerValue] != 1) {
        [defaults removeObjectForKey:@"myeufh_userid"];
        [defaults removeObjectForKey:@"myeufh_userpw"];
        [defaults removeObjectForKey:@"myeufh_userlogin"];
    }
}

@end
