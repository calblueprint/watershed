//
//  WPSelectTaskView.m
//  Watershed
//
//  Created by Jordeen Chang on 11/23/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSelectTaskView.h"

@implementation WPSelectTaskView

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
    _selectTaskTableView = [[UITableView alloc] init];
    [self addSubview:_selectTaskTableView];
    
    _searchField = [({
        UITextField *searchField = [[UITextField alloc] init];
        searchField.font = [UIFont systemFontOfSize:14];
        searchField.textColor = [UIColor wp_paragraph];
        searchField;
    }) wp_addToSuperview:self];
    
}

- (void)updateConstraints {
    
    [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
    [self.selectTaskTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchField.mas_bottom).with.offset(standardMargin);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];

    [super updateConstraints];
}

@end
