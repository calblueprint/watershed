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
#import "WPNetworkingManager.h"
#import "WPTask.h"

@interface WPTasksListViewController ()

@property (nonatomic) WPTasksListView *view;

@end

@implementation WPTasksListViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Tasks";
    self.view.backgroundColor = [UIColor whiteColor];
    FAKIonIcons *addIcon = [FAKIonIcons ios7PlusEmptyIconWithSize:22];
    UIImage *addIconImage = [addIcon imageWithSize:CGSizeMake(22, 22)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithImage:addIconImage
                                  style:UIBarButtonItemStylePlain
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
    addTaskViewController.parent = self;
    [[self navigationController] pushViewController: addTaskViewController animated:YES];
}

- (void)requestAndLoadTasks {
    [self.myTasksTableController requestAndLoadMyTasks];
    [self.allTasksTableController requestAndLoadAllTasks];
}


@end
