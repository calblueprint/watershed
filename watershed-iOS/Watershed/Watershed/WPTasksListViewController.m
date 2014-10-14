//
//  WPTasksListViewController.m
//  
//
//  Created by Jordeen Chang on 9/28/14.
//
//

#import "WPTasksListViewController.h"
#import "WPTasksListView.h"
#import "WPTableViewCell.h"
#import "UIColor+WPColors.h"

@interface WPTasksListViewController ()

@property (nonatomic) WPTasksListView *view;
@property (nonatomic) NSArray *currentTasks;

@end

@implementation WPTasksListViewController {
    UITableView *tableView;
    
}

static NSString *CellIdentifier = @"CellTaskIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    _tasks = @[
               @{@"Task": @"Water Tree", @"Description": @"Please", @"DueDate": @"05/11"},
               @{@"Task": @"Prune Tree", @"Description": @"Pretty please", @"DueDate": @"05/10"},
               @{@"Task": @"Keep Tree Alive", @"Description": @"Cherry on top"},
               @{@"Task": @"Start Tree", @"Description": @"Dig hole", @"DueDate": @"05/12"},
               @{@"Task": @"Put Tree in Hole", @"Description": @"Place it in", @"DueDate": @"05/12"}
               ];
    self.view = [[WPTasksListView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
//    tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, 320, 490)];
    [tableView registerClass:[WPTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    // must set delegate & dataSource, otherwise the the table will be empty and not responsive
//    tableView.backgroundColor = [UIColor wp_lightBlue];
    tableView.delegate = self;
    tableView.dataSource = self;
    
//    NSLog(@"%@", NSStringFromCGRect(self.view.frame));

    // add to canvas
    //I want to add this view to view.tasksTableView
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view.
}

- (void)loadView {
    self.view = [[WPTasksListView alloc] init];
}

- (NSInteger)tableView:(UITableView *)tasksTableView numberOfRowsInSection:(NSInteger)section
{
//    NSString *color = [self tableView:tableView titleForHeaderInSection:section];
    return [_tasks count];
}

- (NSInteger)numberOfRowsInTableView:(UITableView *)tasksTableView {
    return [_tasks count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 1 && indexPath.row == 1) {
//        return 100;
//    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tasksTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"TaskCellIdentifier";
    WPTableViewCell *cell = [tasksTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    //row 1 people get data 1
    NSDictionary *rowData = self.tasks[indexPath.row];
    cell.title = rowData[@"Task"];
    cell.taskDescription = rowData[@"Description"];
    cell.dueDate = rowData[@"DueDate"];
//    cell.backgroundColor = [UIColor whiteColor];
;
    return cell;
}
@end
