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
#import "WPAllTasksTableViewController.h"
#import "UIExtensions.h"

@interface WPTasksListViewController ()

@property (nonatomic) WPTasksListView *view;

@end

@implementation WPTasksListViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Tasks";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)loadView {
    _myTasksTableController = [[WPMyTasksTableViewController alloc] init];
    _allTasksTableController = [[WPAllTasksTableViewController alloc] init];
    [self addChildViewController:_myTasksTableController];
    [self addChildViewController:_allTasksTableController];
    self.view = [[WPTasksListView alloc] initWithFrame:CGRectMake(0,0,0,0)andTableViewController:self];
}

@end
