//
//  WPAppDelegate.m
//  Watershed
//
//  Created by Melissa Huang on 9/15/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPAppDelegate.h"
#import "WPTasksListViewController.h"
#import "WPLoginViewController.h"
#import "WPRootViewController.h"
#import "WPSiteViewController.h"

@implementation WPAppDelegate

+ (WPAppDelegate *)instance {
    return (WPAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    // determine the initial view controller here and instantiate it with [storyboard instantiateViewControllerWithIdentifier:];
    
    // Override point for customization after application launch.
    

    self.window.rootViewController = [[WPRootViewController alloc] init];
    //UIViewController *viewController = [[WPSiteViewController  alloc] init];
    //self.window.rootViewController = viewController;//making a view to root view
    [self.window makeKeyAndVisible];
    
    //[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

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
