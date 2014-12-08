//
//  WPMyTasksTableViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 10/14/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPMyTasksTableViewController.h"
#import "WPTasksTableViewCell.h"
#import "UIExtensions.h"
#import "WPTaskViewController.h"
#import "WPTabBarController.h"
#import "WPNetworkingManager.h"

@interface WPMyTasksTableViewController ()

@property (nonatomic) UITableView *tableView;

@end

static NSString *CellIdentifier = @"CellTaskIdentifier";

@implementation WPMyTasksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    
//    _tasks = @[
//               @{@"Task": @"Water MY Tree", @"Description": @"Please. That would be very very very very very very very very very nice. You're a doll.", @"DueDate": @"05/11"},
//               @{@"Task": @"Prune MY Tree", @"Description": @"Pretty please", @"DueDate": @"05/10"},
//               @{@"Task": @"Keep MY Tree Alive", @"Description": @"Cherry on top"},
//               @{@"Task": @"Start MY Tree", @"Description": @"Dig hole", @"DueDate": @"05/12"},
//               @{@"Task": @"Put MY Tree in Hole", @"Description": @"Place it in", @"DueDate": @"05/12"}
//               ];
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass:[WPTasksTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *userId = [f numberFromString:[[WPNetworkingManager sharedManager] keyChainStore][@"userId"]];

    [[WPNetworkingManager sharedManager] requestMyTasksListWithUser:userId parameters: [[NSMutableDictionary alloc] init] success:^(NSMutableArray *tasksList) {
        self.tasks = tasksList;
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
//    return _tasks.count;
    NSInteger rowCount = 0;
    
    if ([tableView isEqual:self.tableView]) rowCount = self.tasks.count;
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    WPTasksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    NSDictionary *rowData = self.tasks[indexPath.row];
//    cell.title = rowData[@"Task"];
//    cell.taskDescription = rowData[@"Description"];
//    cell.dueDate = rowData[@"DueDate"];
//    return cell;
    
    WPTasksTableViewCell *cellView = nil;
    
    if ([tableView isEqual:self.tableView]) {
        
        cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cellView) {
            cellView = [[WPTasksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:CellIdentifier];
        }
        WPTask *task = self.tasks[indexPath.row];
        cellView.title = task.title;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString *formatString = @"yyyy-MM-dd'T'HH:mm:ss.???";
        [formatter setDateFormat:formatString];
//        NSDate *date = [formatter dateFromString:dateValue];
        
        
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        
        [outputFormatter setDateFormat:@"MM/dd/yyyy"];
        
        NSString *dateStr = [outputFormatter stringFromDate:task.dueDate];

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
//    taskViewController.taskTitle = self.tasks[indexPath.row][@"Task"];
//    taskViewController.taskDescription = self.tasks[indexPath.row][@"Description"];
//    taskViewController.dueDate = self.tasks[indexPath.row][@"DueDate"];
//    [[self.parentViewController navigationController] pushViewController:taskViewController animated:YES];
    
    WPTask *selectedTask = self.tasks[indexPath.row];
    taskViewController.task = selectedTask;
    [[self.parentViewController navigationController] pushViewController:taskViewController animated:YES];
}

@end
