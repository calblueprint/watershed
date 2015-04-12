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
    [self preloadFields];
    self.navigationItem.title = @"Edit Site";
}

// Override
//- (void)updateServerWithSite:(WPSite *)site {
////    site.siteId = self.site.siteId;
//    
//    // Don't request the list of sites, because it is already called in the ViewController's viewWillAppear
//    __weak __typeof(self)weakSelf = self;
//    [[WPNetworkingManager sharedManager] editTaskWithTask:
//                                               parameters:[[NSMutableDictionary alloc] init]
//                                                  success:^(WPTask *task) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        [strongSelf dismissSelf];
//    }];
//}

#pragma mark - Private Methods

- (void)preloadFields {
    self.taskField.text = self.task.title;
    self.taskField.text = @"TESTING";
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
//    [self preloadFields];
}

@end
