//
//  WPTasksListViewController.m
//  
//
//  Created by Jordeen Chang on 9/28/14.
//
//

#import "WPTasksListViewController.h"
#import "WPTasksListView.h"
#import "UIColor+WPColors.h"

@interface WPTasksListViewController ()

@property (nonatomic) WPTasksListView *view;
@property (nonatomic) NSArray *currentTasks;

@end

@implementation WPTasksListViewController {
    UITableView *tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentTasks = [NSArray arrayWithObjects:@"Clean Tree", @"Prune Tree", @"Eat Tree", @"Water Tree", @"Water Tree 2", @"Plant Tree", @"Prune Tree 2", @"Resoil Tree", nil];
    self.view = [[WPTasksListView alloc] init];
    
//    tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 70, 300, 490)];
    
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
    return [_currentTasks count];
}

- (NSInteger)numberOfRowsInTableView:(UITableView *)tasksTableView {
    return [_currentTasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tasksTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tasksTableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    cell.backgroundColor = [UIColor wp_lightBlue];
    cell.textLabel.text = [_currentTasks objectAtIndex:indexPath.row];
;
    return cell;
}
@end
