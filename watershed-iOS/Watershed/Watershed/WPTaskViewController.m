//
//  WPTaskViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 10/19/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTaskViewController.h"
#import "WPTaskView.h"
#import "WPAddFieldReportViewController.h"

@interface WPTaskViewController ()

@property (nonatomic) WPTaskView *view;

@end

@implementation WPTaskViewController

@synthesize task = _task;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.dueDate.text = self.dueDate;
    self.view.taskDescription.text = self.taskDescription;
    self.view.title.text = self.taskTitle;
    self.view.assigneeLabel.text = [NSString stringWithFormat:@"Assigned to %@ by %@", self.assignee, self.assigner];
    self.navigationItem.title = self.task.title;
    [self.view.addFieldReportButton addTarget:self action:@selector(addFieldReportAction) forControlEvents:UIControlEventTouchUpInside];

}

-(void)loadView {
    self.view = [[WPTaskView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addFieldReportAction {
    WPAddFieldReportViewController *addFieldReportViewController = [[WPAddFieldReportViewController alloc] init];
    [[self navigationController] pushViewController:addFieldReportViewController animated:YES];
}

#pragma mark - Setter Methods

-(void)setTask:(WPTask *)task {
    _task = task;
    [self.view configureWithTask:task];
}

#pragma mark - Lazy Instantiation

- (WPTask *)task {
    if (!_task) {
        _task = [[WPTask alloc] init];
    }
    return _task;
}

@end
