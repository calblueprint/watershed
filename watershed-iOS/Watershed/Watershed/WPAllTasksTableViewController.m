//
//  WPAllTasksTableViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 10/14/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTableViewCell.h"
#import "UIColor+WPColors.h"
#import "WPAllTasksTableViewController.h"
#import "Masonry.h"

@interface WPAllTasksTableViewController ()

@property (nonatomic) UITableView *tableView;

@end

static NSString *allTasksIdentifier = @"allTasksCellIdentifier";

@implementation WPAllTasksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _allTasks = @[
               @{@"Task": @"Water Tree", @"Description": @"Please", @"DueDate": @"05/11"},
               @{@"Task": @"Prune Tree", @"Description": @"Pretty please", @"DueDate": @"05/10"},
               @{@"Task": @"Keep Tree Alive", @"Description": @"Cherry on top"},
               @{@"Task": @"Start Tree", @"Description": @"Dig hole", @"DueDate": @"05/12"},
               @{@"Task": @"Put Tree in Hole", @"Description": @"Place it in", @"DueDate": @"05/12"}
               ];
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[WPTableViewCell class] forCellReuseIdentifier:allTasksIdentifier];
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
    return _allTasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:allTasksIdentifier forIndexPath:indexPath];
    
    NSDictionary *rowData = self.allTasks[indexPath.row];
    cell.title = rowData[@"Task"];
    cell.taskDescription = rowData[@"Description"];
    cell.dueDate = rowData[@"DueDate"];
    return cell;
}

@end