//
//  WPTasksListView.m
//  Watershed
//
//  Created by Jordeen Chang on 9/28/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTasksListView.h"
#import "UIView+WPExtensions.h"
#import "UIColor+WPColors.h"
#import "Masonry.h"


@interface WPTasksListView()

@property (nonatomic) UIView *segmentedTasksTabBarView;
@property (nonatomic) UIView *tasksTableView;
@property (nonatomic) UISegmentedControl *tasksSegmentedControl;
//@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *colors;

@end

@implementation WPTasksListView {
    UITableView *tasksTable;
}

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
    
    _tasksSegmentedControl = [({
        NSArray *itemArray = [NSArray arrayWithObjects: @"My Tasks", @"All Tasks", nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
        segmentedControl.frame = CGRectMake(30, 20, 250, 30);
        //TODO --------------- change size of the frame----------------
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.tintColor = [UIColor wp_darkBlue];
        segmentedControl;
    }) wp_addToSuperview:self.segmentedTasksTabBarView];
    
//    tasksTable = [({
//        UITableView *tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 490)];
//        tableView.backgroundColor = [UIColor wp_lightBlue];
//        _colors = [[NSArray alloc] initWithObjects: @"Red", @"Yellow", @"Green",
//                   @"Blue", @"Purpole", nil];
//        tableView.showsHorizontalScrollIndicator = true;
//        tableView;
//    }) wp_addToSuperview:self.tasksTableView];
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
    
    [self.tasksTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedTasksTabBarView.mas_bottom).with.offset(10);
        make.bottom.equalTo(@(-10));
        make.leading.equalTo(@10);
        make.trailing.equalTo(@(-10));
    }];
    
    [super updateConstraints];
}

#pragma mark - Table View Data source

- (NSInteger)numberOfRowsInTableView:(UITableView *)_tableView {
    return _colors.count;
}

- (void)taskSegmentControlAction:(UISegmentedControl *)segment
{
    self.tasksTableView.backgroundColor = [UIColor wp_lightBlue];
    if(segment.selectedSegmentIndex == 0)
    {
        self.tasksTableView.backgroundColor = [UIColor wp_blue];
    }
}


@end
