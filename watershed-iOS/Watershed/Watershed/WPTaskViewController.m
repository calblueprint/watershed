//
//  WPTaskViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 10/19/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTaskView.h"
#import "WPTaskViewController.h"

@interface WPTaskViewController ()

@end

@implementation WPTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Task 1";
}

-(void)loadView {
    self.view = [[WPTaskView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
