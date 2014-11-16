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

- (void) cycleFromViewController: (UIViewController*) oldC
                toViewController: (UIViewController*) newC {
    [oldC willMoveToParentViewController:nil];
    [self addChildViewController:newC];
    
    newC.view.frame = newC.view.frame;
    CGRect endFrame = oldC.view.frame;
    
    [self transitionFromViewController: oldC
                      toViewController: newC
                              duration: 0.25
                               options:0
                            animations:^{
                                newC.view.frame = oldC.view.frame;
                                oldC.view.frame = endFrame;
                            }
                            completion:^(BOOL finished) {
                                [oldC removeFromParentViewController];
                                [newC didMoveToParentViewController:self];
                            }];
}

- (void)pushNewTabBarControllerFromLogin: (WPLoginViewController *)oldC {
    UIViewController *launchingViewController = [self newInitialViewController];
    [self cycleFromViewController:oldC toViewController:launchingViewController];

}

- (void)pushNewLoginControllerFromTab: (WPTabBarController *)oldC {
    UIViewController *launchingViewController = [self newLoginViewController];
    [self cycleFromViewController:oldC toViewController:launchingViewController];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
