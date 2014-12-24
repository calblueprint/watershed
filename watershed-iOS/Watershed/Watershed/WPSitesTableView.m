//
//  WPSitesTableView.m
//  Watershed
//
//  Created by Andrew Millman on 10/26/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSitesTableView.h"

@interface WPSitesTableView ()
@property (nonatomic) UIActivityIndicatorView *indicatorView;
@end

@implementation WPSitesTableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
        make.top.equalTo(@64);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [self.indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(2*standardMargin));
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
