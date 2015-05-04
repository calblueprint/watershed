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
#import "WPEditTaskViewController.h"

@interface WPTaskViewController ()

@property (nonatomic) WPTaskView *view;
@property (nonatomic) WPUser *currUser;

@end

@implementation WPTaskViewController

@synthesize task = _task;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUser];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.task.title;
    [self.view.addFieldReportButton addTarget:self action:@selector(addFieldReportAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view.completed addTarget:self action:@selector(changeCompletion) forControlEvents:UIControlEventTouchUpInside];
}

- (void)getUser {
    self.currUser = [[WPUser alloc] init];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    self.currUser.userId = [f numberFromString:[[WPNetworkingManager sharedManager] keyChainStore][@"user_id"]];
    [[WPNetworkingManager sharedManager] requestUserWithUser:self.currUser parameters:[[NSMutableDictionary alloc] init] success:^(WPUser *user) {
        self.currUser = user;
        if ([self.task.assigner.userId isEqualToNumber:self.currUser.userId] || [self.currUser.role isEqualToNumber:[NSNumber numberWithInt:2]] || [self.currUser.role isEqualToNumber: [NSNumber numberWithInt:1]]) {
            [self setUpRightBarButtonItems];
        }
    }];
}

- (void)loadView {
    self.view = [[WPTaskView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Action Setups

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

- (void)editTask {
    WPEditTaskViewController *editTaskViewController = [[WPEditTaskViewController alloc] init];
    [editTaskViewController setTask:self.task];
    editTaskViewController.taskParent = self;
    [self addChildViewController:editTaskViewController];
    [[self navigationController] pushViewController: editTaskViewController animated:YES];
}

- (void)changeCompletion {
    NSNumberFormatter *userFormatter = [[NSNumberFormatter alloc] init];
    [userFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSMutableDictionary *task2JSON = [[NSMutableDictionary alloc] init];
    if (self.task.assignee != NULL) {
        _task.completed = !_task.completed;
    } else {
        self.task.assignee = self.currUser;
    }
    [[WPNetworkingManager sharedManager] editTaskWithTask:_task parameters:task2JSON success:^(WPTask *task) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


#pragma mark - Navigation Bar Setup

- (void)setUpRightBarButtonItems {
    FAKIonIcons *deleteIcon = [FAKIonIcons androidTrashIconWithSize:26];
    UIImage *deleteIconImage = [deleteIcon imageWithSize:CGSizeMake(24, 24)];
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]
                                     initWithImage:deleteIconImage
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(deleteTask)];
    FAKIonIcons *editIcon = [FAKIonIcons editIconWithSize:26];
    UIImage *editIconImage = [editIcon imageWithSize:CGSizeMake(24, 24)];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithImage:editIconImage
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(editTask)];
    NSMutableArray *barButtonItems = [[NSMutableArray alloc] initWithObjects:deleteButton, editButton, nil];
    [self.navigationItem setRightBarButtonItems:barButtonItems animated:YES];
}


#pragma mark - UIAlertViewDelegate Methods 

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSMutableDictionary *taskJSON = [[NSMutableDictionary alloc] init];
        [[WPNetworkingManager sharedManager] deleteTaskWithTask:_task parameters:taskJSON success:^(WPTask *task) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
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
