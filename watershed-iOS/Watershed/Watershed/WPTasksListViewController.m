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
#import "WPAllTasksTableViewController.h"

@interface WPTasksListViewController ()

@property (nonatomic) WPTasksListView *view;

@end

@implementation WPTasksListViewController {
//    WPAllTasksTableViewController *allTasksController;
}

static NSString *CellIdentifier = @"CellTaskIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    NSLog(@"%@", NSStringFromCGRect(self.view.frame));

    // add to canvas
    //I want to add this view to view.tasksTableView
//    [self.view addSubview:tableView];
    // Do any additional setup after loading the view.
//    allTasksController = [[WPAllTasksTableViewController alloc] init];
//    [self.view addSubview:allTasksController.tableView];
}

- (void)loadView {
    self.view = [[WPTasksListView alloc] init];
}

@end
