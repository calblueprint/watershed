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
#import "UIColor+WPColors.h"
#import "WPAllTasksTableViewController.h"

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
    self.view = [[WPTasksListView alloc] init];
}

@end
