//
//  AppDelegate.m
//  Debate Timer
//
//  Created by Cormac Chester on 3/18/14.
//  Copyright (c) 2014 Extreme Images Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "Appirater.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Skip settings
    self.storeData = [NSUserDefaults standardUserDefaults];
    [self.storeData setBool:YES forKey:@"firstLaunch"];
    NSLog(@"First Launch bool: %d", [self.storeData boolForKey:@"firstLaunch"]);
    
    //Appirater
    [Appirater setAppId:@"886220744"];    // Change for your "Your APP ID"
    [Appirater setDaysUntilPrompt:2];     // Days from first entered the app until prompt
    [Appirater setUsesUntilPrompt:5];     // Number of uses until prompt
    [Appirater setTimeBeforeReminding:2]; // Days until reminding if the user taps "remind me"
    [Appirater setDebug:NO];           // If you set this to YES it will display all the time
    
    [Appirater appLaunched:YES];
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
    [self.storeData setBool:YES forKey:@"firstLaunch"];
    NSLog(@"First Launch bool: %d", [self.storeData boolForKey:@"firstLaunch"]);
}

@end
