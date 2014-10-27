//
//  WPMyTasksTableViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 10/14/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPMyTasksTableViewController.h"
#import "WPTasksTableViewCell.h"
#import "UIColor+WPColors.h"

@interface WPMyTasksTableViewController ()

@property (nonatomic) UITableView *tableView;

@end

static NSString *CellIdentifier = @"CellTaskIdentifier";

@implementation WPMyTasksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tasks = @[
               @{@"Task": @"Water MY Tree", @"Description": @"Please", @"DueDate": @"05/11"},
               @{@"Task": @"Prune MY Tree", @"Description": @"Pretty please", @"DueDate": @"05/10"},
               @{@"Task": @"Keep MY Tree Alive", @"Description": @"Cherry on top"},
               @{@"Task": @"Start MY Tree", @"Description": @"Dig hole", @"DueDate": @"05/12"},
               @{@"Task": @"Put MY Tree in Hole", @"Description": @"Place it in", @"DueDate": @"05/12"}
               ];
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[WPTasksTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPTasksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *rowData = self.tasks[indexPath.row];
    cell.title = rowData[@"Task"];
    cell.taskDescription = rowData[@"Description"];
    cell.dueDate = rowData[@"DueDate"];
    return cell;
}

@end
