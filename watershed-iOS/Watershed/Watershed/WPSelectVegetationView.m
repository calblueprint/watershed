//
//  WPSelectVegetationView.m
//  Watershed
//
//  Created by Andrew Millman on 12/13/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSelectVegetationView.h"

@implementation WPSelectVegetationView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame visibleNavbar:YES];
    if (self) {
        [self createSubviews];
        [self updateConstraints];
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)createSubviews {
    
    _selectVegetationTableView = [({
        UITableView *taskTableView = [[UITableView alloc] init];
        [taskTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        taskTableView;
    }) wp_addToSuperview:self];
}

- (void)updateConstraints {
    
    [self.selectVegetationTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [super updateConstraints];
}

@end
