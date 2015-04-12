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
    FAKIonIcons *deleteIcon = [FAKIonIcons androidTrashIconWithSize:26];
    UIImage *deleteIconImage = [deleteIcon imageWithSize:CGSizeMake(24, 24)];
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]
                                  initWithImage:deleteIconImage
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(deleteTask)];
    self.navigationItem.rightBarButtonItem = deleteButton;
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

- (void)deleteTask {
    UIAlertView *confirmDelete = [[UIAlertView alloc] initWithTitle:@"Confirm Deletion"
                                                            message:@"Are you sure you want to delete this task?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Yes",nil];
    [confirmDelete show];
}

- (void)changeCompletion {
    NSNumberFormatter *userFormatter = [[NSNumberFormatter alloc] init];
    [userFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSMutableDictionary *task2JSON = [[NSMutableDictionary alloc] init];
    _task.completed = !_task.completed;
    __weak __typeof(self)weakSelf = self;
    [[WPNetworkingManager sharedManager] editTaskWithTask:_task parameters:task2JSON success:^(WPTask *task) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        //do i need anything in this block...?
    }];
}

#pragma mark - UIAlertViewDelegate Methods 

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"Hello?");
        NSMutableDictionary *task2JSON = [[NSMutableDictionary alloc] init];
//        [[WPNetworkingManager sharedManager] deleteTaskWithTask:_task parameters:task2JSON success:^(WPTask *task) {
                //what do I do in this block
//        }];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
