//
//  WPTaskViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 10/19/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTaskViewController.h"
#import "WPTaskView.h"

@interface WPTaskViewController ()

@end

@implementation WPTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Task 1";
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.dueDate.text = self.dueDate;
    self.view.taskDescription.text = self.taskDescription;
    self.view.title.text = self.taskTitle;
}

-(void)loadView {
    self.view = [[WPTaskView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
