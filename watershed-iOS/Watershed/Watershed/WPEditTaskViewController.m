//
//  WPEditTaskViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 4/12/15.
//  Copyright (c) 2015 Blueprint. All rights reserved.
//

#import "WPEditTaskViewController.h"
#import "WPNetworkingManager.h"

@implementation WPEditTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Edit Site";
    [self preloadFields];
}

- (void)dismissSelf {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController popViewControllerAnimated:YES];
}

// Override
- (void)updateServerWithSite:(WPTask *)task {
    
    __weak __typeof(self)weakSelf = self;
    [[WPNetworkingManager sharedManager] editTaskWithTask: self.task
                                               parameters:[[NSMutableDictionary alloc] init]
                                                  success:^(WPTask *task) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf dismissSelf];
    }];
}

#pragma mark - Private Methods

- (void)preloadFields {
    self.taskField.text = self.task.title;
    self.dateField.text = self.task.dueDate;
    self.selectedAssignee = self.task.assignee;
    self.assigneeField.text = self.selectedAssignee.name;
    self.selectedMiniSite = self.task.miniSite;
    self.siteField.text = self.selectedMiniSite.name;
    self.descriptionView.text = self.task.taskDescription;
    self.urgentSwitch.selected = self.task.urgent;
}

#pragma mark - Setter Methods

- (void)setTask:(WPTask *)task{
    _task = task;
}

@end
