//
//  WPMyTasksTableViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 10/14/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPMyTasksTableViewController.h"
#import "WPMyTasksTableView.h"
#import "WPTasksTableViewCell.h"
#import "UIExtensions.h"
#import "WPTaskViewController.h"
#import "WPTabBarController.h"
#import "WPNetworkingManager.h"

@interface WPMyTasksTableViewController ()

@property (nonatomic) WPMyTasksTableView *tableView;
@property (nonatomic) UIRefreshControl *refreshControl;

@end

static NSString *CellIdentifier = @"CellTaskIdentifier";

@implementation WPMyTasksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[WPTasksTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(requestAndLoadMyTasks) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestAndLoadMyTasks];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self requestAndLoadMyTasks];
}

#pragma mark - Networking Methods

- (void)requestAndLoadMyTasks {
    __weak __typeof(self)weakSelf = self;
    NSNumberFormatter *userFormatter = [[NSNumberFormatter alloc] init];
    [userFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *userId = [userFormatter numberFromString:[[WPNetworkingManager sharedManager] keyChainStore][@"user_id"]];

    [[WPNetworkingManager sharedManager] requestMyTasksListWithUser:userId parameters: [[NSMutableDictionary alloc] init] success:^(NSMutableArray *tasksList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.tasks = tasksList;
        [strongSelf.tableView reloadData];
        [self.tableView stopIndicator];
        [self.refreshControl endRefreshing];
    }];
}


- (void)loadView {
    self.tableView = [[WPMyTasksTableView alloc] init];
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

    if ([tableView isEqual:self.tableView]) rowCount = self.tasks.count;
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    WPTasksTableViewCell *cellView = nil;

    if ([tableView isEqual:self.tableView]) {

        cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (!cellView) {
            cellView = [[WPTasksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:CellIdentifier];
        }
        WPTask *task = self.tasks[indexPath.row];
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

    WPTask *selectedTask = self.tasks[indexPath.row];
    taskViewController.task = selectedTask;
    [[self.parentViewController navigationController] pushViewController:taskViewController animated:YES];
}

@end
