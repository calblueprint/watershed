//
//  WPFieldReportViewController.m
//  Watershed
//
//  Created by Andrew Millman on 11/9/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPFieldReportViewController.h"
#import "WPFieldReportView.h"

@interface WPFieldReportViewController ()

@end

@implementation WPFieldReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Field Report";
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)loadView {
    self.view = [[WPFieldReportView alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self isMovingToParentViewController]) {
        //view controller is being pushed on
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self isMovingFromParentViewController]) {
        //view controller is being popped off
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
}

@end
