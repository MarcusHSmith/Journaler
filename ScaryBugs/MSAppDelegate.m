//
//  MSAppDelegate.m
//  Journaler
//
//  Created by Marcus Smith on 4/5/14.
//  Copyright (c) 2014 Marcus Smith. All rights reserved.
//

#import "MSAppDelegate.h"
#import "MSMasterViewController.h"
#import "MSJournalerDoc.h"
#import <Parse/Parse.h>

@implementation MSAppDelegate
@synthesize bugs;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Parse setApplicationId:@"GmPMTAP84gL4Ob2aOkryvoO94533Cht5WSLrypoD"
                  clientKey:@"BpGsFpZ6lte0RAdS8HJes2fqrXTbO2R66H7TQNPy"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    UITabBarController *tabBarController = (UITabBarController *) self.window.rootViewController;
    MSMasterViewController *masterController = [((UINavigationController *)[tabBarController.viewControllers objectAtIndex:0]).viewControllers objectAtIndex:0];
    
    long i = tabBarController.viewControllers.count;
    for (int j = 0; j < i; j++) {
        UINavigationController *navController = [tabBarController.viewControllers objectAtIndex:j];
        [[navController.viewControllers objectAtIndex:0] viewDidLoad];
    }
    
    bugs = [[NSMutableArray alloc]init];
    
    masterController.bugs = bugs;
    
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
}

@end
