//
//  WPTasksListViewController.m
//  
//
//  Created by Jordeen Chang on 9/28/14.
//
//

#import "WPTasksListViewController.h"
#import "WPTasksListView.h"
#import "WPTasksTableViewCell.h"
#import "UIExtensions.h"
#import "WPAddTaskViewController.h"

@interface WPTasksListViewController ()

@property (nonatomic) WPTasksListView *view;

@end

@implementation WPTasksListViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Tasks";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"+"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(newTaskForm:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)loadView {
    _myTasksTableController = [[WPMyTasksTableViewController alloc] init];
    _allTasksTableController = [[WPAllTasksTableViewController alloc] init];
    [self addChildViewController:_myTasksTableController];
    [self addChildViewController:_allTasksTableController];
    self.view = [[WPTasksListView alloc] initWithFrame:CGRectZero  andTableViewController:self];
}

- (void)newTaskForm:(UIButton *)sender {
    WPAddTaskViewController *addTaskViewController = [[WPAddTaskViewController alloc] init];
    [[self navigationController] pushViewController: addTaskViewController animated:YES];
}


@end
