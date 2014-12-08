//
//  WPAllTasksTableViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 10/14/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTasksTableViewCell.h"
#import "WPAllTasksTableViewController.h"
#import "UIExtensions.h"
#import "WPTaskViewController.h"
#import "WPNetworkingManager.h"
#import "WPTask.h"

@interface WPAllTasksTableViewController ()

@property (nonatomic) UITableView *tableView;

@end

static NSString *allTasksIdentifier = @"allTasksCellIdentifier";

@implementation WPAllTasksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _allTasks = @[
               @{@"Task": @"Water Tree", @"Description": @"Please", @"DueDate": @"05/11", @"Assigner": @"Derek", @"Assignee": @"Lala"},
               @{@"Task": @"Prune Tree", @"Description": @"Pretty please", @"DueDate": @"05/10", @"Assigner": @"Derek", @"Assignee": @"Lala"},
               @{@"Task": @"Keep Tree Alive Lot of text. Lot of Text. Lot of Text. Lot of Text.", @"Description": @"Cherry on top. Hello lots of text. Wow that's a lot of text. A lot of text. A lot of Text. A Lot of Text. A Lot Of Text. Lot of text. Lot of text. Lot of text. ", @"Assigner": @"Derek", @"Assignee": @"Lala"},
               @{@"Task": @"Start Tree", @"Description": @"Dig hole", @"DueDate": @"05/12", @"Assigner": @"Derek", @"Assignee": @"Lala"},
               @{@"Task": @"Put Tree in Hole", @"Description": @"Place it in", @"DueDate": @"05/12", @"Assigner": @"Derek", @"Assignee": @"Lala"}
               ];
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[WPTasksTableViewCell class] forCellReuseIdentifier:allTasksIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [[WPNetworkingManager sharedManager] requestSitesListWithParameters:[[NSMutableDictionary alloc] init] success:^(NSMutableArray *sitesList) {
        self.allTasks = sitesList;
        [self.tableView reloadData];
    }];
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
//    return _allTasks.count;
    
    NSInteger rowCount = 0;
    
    if ([tableView isEqual:self.tableView]) rowCount = self.allTasks.count;
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    WPTasksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:allTasksIdentifier forIndexPath:indexPath];
//    
//    NSDictionary *rowData = self.allTasks[indexPath.row];
//    cell.title = rowData[@"Task"];
//    cell.taskDescription = rowData[@"Description"];
//    cell.dueDate = rowData[@"DueDate"];
//    return cell;
//    
//    
    WPTasksTableViewCell *cellView = nil;
    
    if ([tableView isEqual:self.tableView]) {
        
        cellView = [tableView dequeueReusableCellWithIdentifier:allTasksIdentifier];
        
        if (!cellView) {
            cellView = [[WPTasksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:allTasksIdentifier];
        }
        WPTask *task = self.allTasks[indexPath.row];
        cellView.title = task.title;
        cellView.dueDate = task.dueDate;
        cellView.taskDescription = task.taskDescription;
        cellView.completed = task.completed;
    }
    return cellView;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    WPTaskViewController *taskViewController = [[WPTaskViewController alloc] init];
//    taskViewController.taskTitle = self.allTasks[indexPath.row][@"Task"];
//    taskViewController.taskDescription = self.allTasks[indexPath.row][@"Description"];
//    taskViewController.dueDate = self.allTasks[indexPath.row][@"DueDate"];
//    taskViewController.assignee = self.allTasks[indexPath.row][@"Assignee"];
//    taskViewController.assigner = self.allTasks[indexPath.row][@"Assigner"];
    
    WPTask *selectedTask = self.allTasks[indexPath.row];
    taskViewController.task = selectedTask;
    [[self.parentViewController navigationController] pushViewController:taskViewController animated:YES];
}

@end
