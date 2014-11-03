//
//  WPTasksListView.m
//  Watershed
//
//  Created by Jordeen Chang on 9/28/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTasksListView.h"
#import "WPAllTasksTableViewController.h"
#import "WPMyTasksTableViewController.h"
#import "UIExtensions.h"
#import "WPTasksListViewController.h"


@interface WPTasksListView()

@property (nonatomic) UIView *segmentedTasksTabBarView;
@property (nonatomic) UIView *tasksTableView;
@property (nonatomic) UISegmentedControl *tasksSegmentedControl;
@property (nonatomic) WPTasksListViewController *parentTasksListViewController;
@property (nonatomic) UITableView *currentView;
@property (nonatomic) NSArray *colors;

@end

@implementation WPTasksListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame visibleNavbar:YES];
    if (self) {
        [self createSubviews];
        [self setUpActions];
        [self updateConstraints];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame andTableViewController:(WPTasksListViewController *)tableViewController {
    self = [super initWithFrame:frame visibleNavbar:YES];
    self.parentTasksListViewController = tableViewController;
    if (self) {
        [self createSubviews];
        [self setUpActions];
        [self updateConstraints];
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)createSubviews {
    _segmentedTasksTabBarView = [({
        UIView *view = [[UIView alloc] init];
        view;
    }) wp_addToSuperview:self];
    
    _tasksTableView = [({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor wp_darkBlue];
        view;
    }) wp_addToSuperview:self];

    _currentView = [({
        UITableView *myView = _parentTasksListViewController.myTasksTableController.tableView;
        myView;
    }) wp_addToSuperview:self.tasksTableView];

    _tasksSegmentedControl = [({
        NSArray *itemArray = [NSArray arrayWithObjects: @"My Tasks", @"All Tasks", nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.tintColor = [UIColor wp_darkBlue];
        segmentedControl;
    }) wp_addToSuperview:self.segmentedTasksTabBarView];
}

- (void)setUpActions {
    [self.tasksSegmentedControl addTarget:self action:@selector(taskSegmentControlAction:) forControlEvents: UIControlEventValueChanged];
}

- (void)updateConstraints {
    
    [self.segmentedTasksTabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
        make.height.equalTo(@50);
    }];
    
    [self.tasksSegmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@20);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];
    
    [self.tasksTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedTasksTabBarView.mas_bottom).with.offset(10);
        make.bottom.equalTo(@(-standardMargin));
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];
    
    [self.tasksTableView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [super updateConstraints];
}

- (void)taskSegmentControlAction:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex == 0)
    {
        [self.tasksTableView addSubview:_parentTasksListViewController.myTasksTableController.tableView];
    } else {
        [self.tasksTableView addSubview:_parentTasksListViewController.allTasksTableController.tableView];
    }
    [self setNeedsUpdateConstraints];
}


@end
