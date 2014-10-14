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
               @{@"Task": @"Water Tree", @"Description": @"Please"},
               @{@"Task": @"Prune Tree", @"Description": @"Pretty Please"},
               @{@"Task": @"Keep Tree Alive", @"Description": @"Cherry On Top"}
               ];
    self.view = [[WPTasksListView alloc] init];
    
//    tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 70, 300, 490)];
    [tableView registerClass:[WPTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    // must set delegate & dataSource, otherwise the the table will be empty and not responsive
    tableView.backgroundColor = [UIColor wp_lightBlue];
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
    cell.backgroundColor = [UIColor wp_lightBlue];
//    cell.textLabel.text = [_currentTasks objectAtIndex:indexPath.row];
;
    return cell;
}
@end
