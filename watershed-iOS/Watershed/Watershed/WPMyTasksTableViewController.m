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

    self.tableView = [[WPMyTasksTableView alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[WPTasksTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.refreshControl addTarget:self action:@selector(requestAndLoadMyTasks) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    [self requestAndLoadMyTasks];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return _tasks.count;
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

#pragma mark - Networking Methods

- (void)requestAndLoadMyTasks {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *userId = [f numberFromString:[[WPNetworkingManager sharedManager] keyChainStore][@"user_id"]];

    [[WPNetworkingManager sharedManager] requestMyTasksListWithUser:userId parameters: [[NSMutableDictionary alloc] init] success:^(NSMutableArray *tasksList) {
        self.tasks = tasksList;
        [self.tableView reloadData];
        [self.tableView stopIndicator];
        [self.refreshControl endRefreshing];
    }];
}

@end
