//
//  WPRootViewController.m
//  Watershed
//
//  Created by Melissa Huang on 10/1/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPRootViewController.h"
#import "WPNetworkingManager.h"

@interface WPRootViewController ()

@property (nonatomic, strong) UIViewController  *currentViewController;


@end

@implementation WPRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIViewController *launchingViewController = nil;
    UICKeyChainStore *store = [[WPNetworkingManager sharedManager] keyChainStore];
    if (store[@"auth_token"] && store[@"email"]) {
        launchingViewController = [self newInitialViewController];
    } else {
        launchingViewController = [self newLoginViewController];
    }
//    launchingViewController = [self newInitialViewController]; //remove this later
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

- (void)cycleFromViewController:(UIViewController*)oldVC
               toViewController:(UIViewController*)newVC {
    [oldVC willMoveToParentViewController:nil];
    [self addChildViewController:newVC];
    
    newVC.view.frame = newVC.view.frame;
    CGRect endFrame = oldVC.view.frame;
    
    [self transitionFromViewController: oldVC
                      toViewController: newVC
                              duration: 0.1
                               options:0
                            animations:^{
                                newVC.view.frame = oldVC.view.frame;
                                oldVC.view.frame = endFrame;
                            }
                            completion:^(BOOL finished) {
                                [oldVC removeFromParentViewController];
                                [newVC didMoveToParentViewController:self];
                            }];
}

- (void)pushNewTabBarControllerFromLogin:(WPLoginViewController *)oldVC {
    UIViewController *launchingViewController = [self newInitialViewController];
    [self cycleFromViewController:oldVC toViewController:launchingViewController];

}

- (void)pushNewLoginControllerFromTab:(WPTabBarController *)oldVC {
    UIViewController *launchingViewController = [self newLoginViewController];
    [self cycleFromViewController:oldVC toViewController:launchingViewController];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
