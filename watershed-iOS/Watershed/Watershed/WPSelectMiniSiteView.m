//
//  WPSelectMiniSiteView.m
//  Watershed
//
//  Created by Jordeen Chang on 11/24/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSelectMiniSiteView.h"

@implementation WPSelectMiniSiteView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame visibleNavbar:NO];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubviews];
        [self updateConstraints];
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)createSubviews {
    _selectMiniSiteTableView = [({
        UITableView *miniSiteTableView = [[UITableView alloc] init];
        [miniSiteTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        miniSiteTableView;
    }) wp_addToSuperview:self];
    
    _searchField = [({
        UITextField *searchField = [[UITextField alloc] init];
        searchField.font = [UIFont systemFontOfSize:14];
        searchField.textColor = [UIColor wp_paragraph];
        searchField;
    }) wp_addToSuperview:self];
    
}

- (void)updateConstraints {
    //
    //    [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(@(topMargin));
    //        make.leading.equalTo(@0);
    //        make.trailing.equalTo(@0);
    //    }];
    
    [self.selectMiniSiteTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        //        make.top.equalTo(self.searchField.mas_bottom);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [super updateConstraints];
}

@end
