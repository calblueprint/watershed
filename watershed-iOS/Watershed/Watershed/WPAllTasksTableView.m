//
//  WPAllTasksTableView.m
//  Watershed
//
//  Created by Andrew Millman on 12/25/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPAllTasksTableView.h"

@interface WPAllTasksTableView ()
@property (nonatomic) UIActivityIndicatorView *indicatorView;
@end

@implementation WPAllTasksTableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {

    self.tableHeaderView = [[UIView alloc] init];

    _indicatorView = [({
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [view startAnimating];
        view;
    }) wp_addToSuperview:self.tableHeaderView];
}

- (void)updateConstraints {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];

    [self.indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(2 * standardMargin));
        make.centerX.equalTo(self.mas_centerX);
    }];

    [super updateConstraints];
}

#pragma mark - Public Methods

- (void)stopIndicator {
    [self.indicatorView stopAnimating];
    self.indicatorView.alpha = 0;
}

@end
