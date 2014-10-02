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

@end

@implementation WPTasksListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
//        [self setUpActions];
        [self updateConstraints];
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)createSubviews {
    _segmentedTasksTabBarView = [({
//        UIView *view = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 100, 100))];
        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = [UIColor wp_darkBlue];
        view;
    }) wp_addToSuperview:self];
    
    _tasksTableView = [({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor wp_darkBlue];
        view;
    }) wp_addToSuperview:self];

    //-----------------FIGURE OUT WHAT SCROLL DOES----------------
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 435)];
    scroll.contentSize = CGSizeMake(320, 700);
    scroll.showsHorizontalScrollIndicator = YES;
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"My Tasks", @"All Tasks", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(30, 30, 250, 30);
//    segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
//    [segmentedControl addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor wp_darkBlue];
    [scroll addSubview:segmentedControl];
//    [segmentedControl release];
    [self.segmentedTasksTabBarView addSubview:segmentedControl];
}

- (void)setUpActions {
    // Here is where you set up buttons taps and gesture recognizers.
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


@end
