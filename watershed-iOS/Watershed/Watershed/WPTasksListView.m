//
//  WPTasksListView.m
//  Watershed
//
//  Created by Jordeen Chang on 9/28/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTasksListView.h"
#import "WPMyTasksTableView.h"
#import "WPAllTasksTableView.h"
#import "WPAllTasksTableViewController.h"
#import "WPMyTasksTableViewController.h"
#import "UIView+WPExtensions.h"
#import "UIColor+WPColors.h"
#import "Masonry.h"


@interface WPTasksListView()

@property (nonatomic) UIView *segmentedTasksTabBarView;
@property (nonatomic) UIView *tasksTableView;
@property (nonatomic) UISegmentedControl *tasksSegmentedControl;
@property (nonatomic) WPMyTasksTableViewController *myTasksTableController;
@property (nonatomic) WPAllTasksTableViewController *allTasksTableController;
@property (nonatomic) UITableView *currentView;
@property (nonatomic) NSArray *colors;

@end

@implementation WPTasksListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
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
    
//    _myTasksTable = ({
//        _myTasksTableController = [[WPMyTasksTableViewController alloc] init];
//        WPMyTasksTableView *myTasks = _myTasksTableController.tableView;
//        myTasks;
//    });
//    
    _myTasksTableController = ({
//        WPMyTasksTableViewController *myController = [[WPMyTasksTableViewController alloc] init];
        WPMyTasksTableViewController *myController =
        [[WPMyTasksTableViewController alloc] init];
        myController;
    });
    
    _currentView = [({
        UITableView *myView= _myTasksTableController.tableView;
        myView;
    }) wp_addToSuperview:self.tasksTableView];

    _allTasksTableController = ({
        WPAllTasksTableViewController *allController = [[WPAllTasksTableViewController alloc] init];
        allController;
    });

    _tasksSegmentedControl = [({
        NSArray *itemArray = [NSArray arrayWithObjects: @"My Tasks", @"All Tasks", nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.tintColor = [UIColor wp_darkBlue];
        segmentedControl;
    }) wp_addToSuperview:self.segmentedTasksTabBarView];
}

- (void)setUpActions {
    // Here is where you set up buttons taps and gesture recognizers.
    [self.tasksSegmentedControl addTarget:self action:@selector(taskSegmentControlAction:) forControlEvents: UIControlEventValueChanged];
}

- (void)updateConstraints {
    
    [self.segmentedTasksTabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@10);
        make.trailing.equalTo(@(-10));
        make.height.equalTo(@60);
    }];
    
    [self.tasksSegmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.leading.equalTo(@10);
        make.trailing.equalTo(@(-10));
    }];
    
    [self.tasksTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedTasksTabBarView.mas_bottom).with.offset(10);
        make.bottom.equalTo(@(-10));
        make.leading.equalTo(@10);
        make.trailing.equalTo(@(-10));
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
        [self.tasksTableView addSubview:_myTasksTableController.tableView];
    } else {
        [self.tasksTableView addSubview:_allTasksTableController.tableView];
        [self setNeedsUpdateConstraints];
    }
}


@end
