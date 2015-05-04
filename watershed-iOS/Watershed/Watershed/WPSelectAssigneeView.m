//
//  WPSelectAssigneeView.m
//  Watershed
//
//  Created by Jordeen Chang on 11/24/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSelectAssigneeView.h"

@implementation WPSelectAssigneeView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame visibleNavbar:YES];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubviews];
        [self updateConstraints];
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)createSubviews {
    _selectAssigneeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self addSubview:_selectAssigneeTableView];

}

- (void)updateConstraints {

    [self.selectAssigneeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [super updateConstraints];
}

@end
