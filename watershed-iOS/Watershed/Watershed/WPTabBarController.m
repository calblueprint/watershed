//
//  WPTabBarController.m
//  Watershed
//
//  Created by Melissa Huang on 10/1/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPAppDelegate.h"
#import "WPTabBarController.h"
#import "WPTasksListViewController.h"
#import "WPSitesListViewController.h"
#import "WPProfileViewController.h"

@interface WPTabBarController ()

@end

@implementation WPTabBarController

+ (WPTabBarController *)activeCoreTabBarController {
    UIViewController *rootViewController = [WPAppDelegate instance].window.rootViewController;
    UIViewController *tabBarController = rootViewController.childViewControllers[0];
    return (WPTabBarController *)tabBarController;
}

- (instancetype)init {
    return [super init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    // TODO: change color
    self.tabBar.tintColor = [UIColor grayColor];
    self.tabBar.translucent = NO;
    
    
    
    self.viewControllers = ({
        NSArray *titles = @[
                            NSLocalizedString(@"Tasks", HNNoLocalizationComment),
                            NSLocalizedString(@"Sites", HNNoLocalizationComment),
                            NSLocalizedString(@"Profile", HNNoLocalizationComment)
                            ];
        
        WPTasksListViewController *tasksListViewController = [[WPTasksListViewController alloc] init];
        WPSitesListViewController *sitesListViewController = [[WPSitesListViewController alloc] init];
        WPProfileViewController *profileViewController = [[WPProfileViewController alloc] init];
        NSArray *rootViewControllers = @[
                                         tasksListViewController,
                                         sitesListViewController,
                                         profileViewController
                                         ];
        
        NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:3];
        
        for (NSInteger i = 0; i < [rootViewControllers count]; i++) {
            UINavigationController *navigationController = [[UINavigationController alloc] init];
            navigationController.delegate = self;
            navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[i] image:nil tag:i];
            navigationController.viewControllers = @[ rootViewControllers[i] ];
            [viewControllers addObject:navigationController];
        }
        
        viewControllers;
    });
    
}

- (UINavigationController *)activeTabNavigationController {
    return [self.viewControllers objectAtIndex:self.selectedIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
