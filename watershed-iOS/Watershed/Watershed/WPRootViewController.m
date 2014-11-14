//
//  WPRootViewController.m
//  Watershed
//
//  Created by Melissa Huang on 10/1/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPRootViewController.h"

@interface WPRootViewController ()

@property (nonatomic, strong) UIViewController  *currentViewController;


@end

@implementation WPRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIViewController *launchingViewController = [self newInitialViewController];
    UIViewController *launchingViewController = [self newLoginViewController];
    [self showViewController:launchingViewController];
}

- (UIViewController *)newInitialViewController {
    return [[WPTabBarController alloc] init];
}

- (UIViewController *)newLoginViewController {
    return [[WPLoginViewController alloc] init];
}

- (void)showViewController:(UIViewController *)initialViewController {
    [self addChildViewController:initialViewController];
    [self.view addSubview:initialViewController.view];
    self.currentViewController = initialViewController;
}

- (void)pushNewTabBarController {
    UIViewController *launchingViewController = [self newInitialViewController];
    [self showViewController:launchingViewController];

}

- (void)pushNewLoginController {
    UIViewController *launchingViewController = [self newLoginViewController];
    [self showViewController:launchingViewController];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
