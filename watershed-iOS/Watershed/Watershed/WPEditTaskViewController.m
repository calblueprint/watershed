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
    self.navigationItem.title = @"Edit Task";
    [self preloadFields];
}

- (void)dismissSelf {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.taskParent setTask:self.task];
    [self.navigationController popViewControllerAnimated:YES];
}

// Override
- (void)updateServerWithTask:(WPTask *)task {
    task.taskId = self.task.taskId;
    __weak __typeof(self)weakSelf = self;
    [[WPNetworkingManager sharedManager] editTaskWithTask: task
                                               parameters:[[NSMutableDictionary alloc] init]
                                                  success:^(WPTask *taskResponse){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
                                                      strongSelf.task = taskResponse;
        [strongSelf dismissSelf];
    }];
}

#pragma mark - Private Methods

- (void)preloadFields {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MMM dd, yyyy"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    NSDate *date  = [dateFormat dateFromString: self.task.dueDate];
    NSString *dueDateString = [outputFormatter stringFromDate:date];
    
    self.dateField.text = dueDateString;
    self.taskField.text = self.task.title;
    self.selectedAssignee = self.task.assignee;
    self.assigneeField.text = self.selectedAssignee.name;
    self.selectedMiniSite = self.task.miniSite;
    self.siteField.text = self.selectedMiniSite.name;
    self.descriptionView.text = self.task.taskDescription;
    self.urgentSwitch.selected = self.task.urgent;
}



@end
