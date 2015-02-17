//
//  WPMyTasksTableView.m
//  Watershed
//
//  Created by Andrew on 12/25/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPMyTasksTableView.h"

@interface WPMyTasksTableView ()
@property (nonatomic) UIActivityIndicatorView *indicatorView;
@end

@implementation WPMyTasksTableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {

    _indicatorView = [({
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [view startAnimating];
        view;
    }) wp_addToSuperview:self];
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
