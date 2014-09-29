//
//  WPTasksListView.m
//  Watershed
//
//  Created by Jordeen Chang on 9/28/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTasksListView.h"

@interface WPTasksListView()

@property (nonatomic) UIView *segmentedTasksTabBarView;
@property (nonatomic) UIView *tasksTableView;

@end

@implementation WPTasksListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        [self createSubviews];
//        [self setUpActions];
        [self updateConstraints];
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)createSubviews {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = 
//    _segmentedTasksTabBarView = [({
//        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = [UIColor blueColor];
//        view;
//    }) mm_addToSuperview:self];
//    
//    _tasksTableView = [({
//        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = [UIColor redColor];
//        view;
//    }) mm_addToSuperview:self];
}
//
//- (void)setUpActions {
//    // Here is where you set up buttons taps and gesture recognizers.
//}
//
//- (void)updateConstraints {
//    [self.segmentedTasksTabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@100);
//        make.leading.equalTo(@10);
//        make.trailing.equalTo(@(-10));
//        make.height.equalTo(@100);
//    }];
//    
//    [self.tasksTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.sampleView.mas_bottom).with.offset(10);
//        make.bottom.equalTo(@(-10));
//        make.leading.equalTo(@10);
//        make.trailing.equalTo(@(-10));
//    }];
//    
//    [super updateConstraints];
//}


@end
