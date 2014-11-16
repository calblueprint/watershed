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
                toViewController: (UIViewController*) newC
{
    [oldC willMoveToParentViewController:nil];                        // 1
    [self addChildViewController:newC];
    
    newC.view.frame = newC.view.frame;                      // 2
    CGRect endFrame = oldC.view.frame;
    
    [self transitionFromViewController: oldC toViewController: newC   // 3
                              duration: 1 options:0
                            animations:^{
                                newC.view.frame = oldC.view.frame;                       // 4
                                oldC.view.frame = endFrame;
                            }
                            completion:^(BOOL finished) {
                                [oldC removeFromParentViewController];                   // 5
                                [newC didMoveToParentViewController:self];
                            }];
}

- (void)pushNewTabBarControllerFromLogin: (WPLoginViewController *)oldC {
    UIViewController *launchingViewController = [self newInitialViewController];
//    [self showViewController:launchingViewController];
    [self cycleFromViewController:oldC toViewController:launchingViewController];

}

- (void)pushNewLoginControllerFromTab: (WPTabBarController *)oldC {
    UIViewController *launchingViewController = [self newLoginViewController];
//    [self showViewController:launchingViewController];
    [self cycleFromViewController:oldC toViewController:launchingViewController];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
