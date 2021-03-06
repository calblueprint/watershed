//
//  WPAllTasksTableViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 10/14/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTasksTableViewCell.h"
#import "WPAllTasksTableViewController.h"
#import "WPAllTasksTableView.h"
#import "UIExtensions.h"
#import "WPTaskViewController.h"
#import "WPNetworkingManager.h"
#import "WPTask.h"

@interface WPAllTasksTableViewController ()

@property (nonatomic) WPAllTasksTableView *tableView;
@property (nonatomic) UIRefreshControl *refreshControl;

@end

static NSString *allTasksIdentifier = @"allTasksCellIdentifier";

@implementation WPAllTasksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[WPTasksTableViewCell class] forCellReuseIdentifier:allTasksIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(requestAndLoadAllTasks) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestAndLoadAllTasks];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self requestAndLoadAllTasks];
}

- (void)loadView {
    self.tableView = [[WPAllTasksTableView alloc] init];
}

#pragma mark - Networking Methods

- (void)requestAndLoadAllTasks {
    __weak __typeof(self)weakSelf = self;
    [[WPNetworkingManager sharedManager] requestTasksListWithParameters:[[NSMutableDictionary alloc] init] success:^(NSMutableArray *tasksList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.allTasks = tasksList;
        [strongSelf.tableView reloadData];
        [self.tableView stopIndicator];
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = 0;

    if ([tableView isEqual:self.tableView]) rowCount = self.allTasks.count;
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    WPTasksTableViewCell *cellView = nil;

    if ([tableView isEqual:self.tableView]) {

        cellView = [tableView dequeueReusableCellWithIdentifier:allTasksIdentifier];

        if (!cellView) {
            cellView = [[WPTasksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:allTasksIdentifier];
        }
        WPTask *task = self.allTasks[indexPath.row];
        cellView.title = task.title;

        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"MM/dd/yyyy"];

        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];

        NSDate *date  = [dateFormat dateFromString: task.dueDate];
        NSString *dueDateString = [outputFormatter stringFromDate:date];
        cellView.dueDate = dueDateString;
        cellView.taskDescription = task.taskDescription;
        cellView.completed = task.completed;
    }
    return cellView;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    WPTaskViewController *taskViewController = [[WPTaskViewController alloc] init];
    WPTask *selectedTask = self.allTasks[indexPath.row];
    taskViewController.task = selectedTask;
    [[self.parentViewController navigationController] pushViewController:taskViewController animated:YES];
}

@end
