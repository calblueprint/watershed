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
#import "WPSitesTableViewController.h"
#import "WPProfileViewController.h"
#import "UIColor+WPColors.h"

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
    
//    self.delegate = self;
    // TODO: change color
    self.tabBar.tintColor = [UIColor wp_blue];
    self.tabBar.translucent = NO;
    
    
    
    self.viewControllers = ({
        NSArray *titles = @[
                            NSLocalizedString(@"Tasks", HNNoLocalizationComment),
                            NSLocalizedString(@"Sites", HNNoLocalizationComment),
                            NSLocalizedString(@"Profile", HNNoLocalizationComment)
                            ];
        

        UIImage *checkImage = [self imageResize:[UIImage imageNamed:@"tasks_gray.png"] andResizeTo:CGSizeMake(28, 28)];
        
        UIImage *treeImage = [self imageResize:[UIImage imageNamed:@"sites_gray.png"] andResizeTo:CGSizeMake(28, 28)];

        UIImage *profileImage = [self imageResize:[UIImage imageNamed:@"profile_gray.png"] andResizeTo:CGSizeMake(28, 28)];

        NSArray *images = @[
                            checkImage,
                            treeImage,
                            profileImage
                            ];
        
        WPTasksListViewController *tasksListViewController = [[WPTasksListViewController alloc] init];
        //CHANGE LATAR
        WPSitesTableViewController *sitesTableViewController = [[WPSitesTableViewController alloc] init];
        WPProfileViewController *profileViewController = [[WPProfileViewController alloc] init];
        NSArray *rootViewControllers = @[
                                         tasksListViewController,
                                         sitesTableViewController,
                                         profileViewController
                                         ];
        
        NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:3];
        
        for (NSInteger i = 0; i < [rootViewControllers count]; i++) {
            UINavigationController *navigationController = [[UINavigationController alloc] init];
            navigationController.delegate = self;
            navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[i] image:images[i] tag:i];
            navigationController.viewControllers = @[ rootViewControllers[i] ];
            [viewControllers addObject:navigationController];
        }
        
        viewControllers;
    });
    
}

- (UIImage *)imageResize:(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UINavigationController *)activeTabNavigationController {
    return [self.viewControllers objectAtIndex:self.selectedIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
