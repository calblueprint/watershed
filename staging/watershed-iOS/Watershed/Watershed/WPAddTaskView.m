//
//  WPAddTaskView.m
//  Watershed
//
//  Created by Jordeen Chang on 11/21/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPAddTaskView.h"

@interface WPAddTaskView ()


@end

@implementation WPAddTaskView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame visibleNavbar:YES];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubviews];
        [self updateConstraints];
    }

    self.taskFormTableView.scrollEnabled = NO;
//    [self.taskFormTableView reloadData];
    return self;
}

#pragma mark - View Hierarchy


- (void)createSubviews {

    _taskFormTableView = [[UITableView alloc] init];
    [_taskFormTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

    [self addSubview:_taskFormTableView];
    
}

- (void)updateConstraints {
    
    [self.taskFormTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [super updateConstraints];
}


@end
