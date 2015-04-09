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
#import "WPNetworkingManager.h"

@interface WPTaskViewController ()

@property (nonatomic) WPTaskView *view;

@end

@implementation WPTaskViewController

@synthesize task = _task;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.task.title;
    [self.view.addFieldReportButton addTarget:self action:@selector(addFieldReportAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view.completed addTarget:self action:@selector(changeCompletion) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadView {
    self.view = [[WPTaskView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addFieldReportAction {
    WPAddFieldReportViewController *addFieldReportViewController = [[WPAddFieldReportViewController alloc] init];
    [[self navigationController] pushViewController:addFieldReportViewController animated:YES];
}

- (void)changeCompletion {
    NSNumberFormatter *userFormatter = [[NSNumberFormatter alloc] init];
    [userFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *isCompletedString = [NSString stringWithFormat:@"%i", [self.view.completed isSelected]];
    NSString *isUrgentString = [NSString stringWithFormat:@"%i", self.task.urgent];
    NSDictionary *taskJSON = @{
                               @"title" : self.task.title,
                               @"urgent" : isUrgentString,
                               @"completed" : isCompletedString
                               };
    NSMutableDictionary *task2JSON = [[NSMutableDictionary alloc] init];
    _task.completed = !_task.completed;
    __weak __typeof(self)weakSelf = self;
    [[WPNetworkingManager sharedManager] editTaskWithTask:_task parameters:task2JSON success:^(WPTask *task) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //do i need anything in this block...?
    }];
}

#pragma mark - Setter Methods

- (void)setTask:(WPTask *)task {
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