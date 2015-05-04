//
//  WPPromoteView.m
//  Watershed
//
//  Created by Jordeen Chang on 5/3/15.
//  Copyright (c) 2015 Blueprint. All rights reserved.
//

#import "WPPromoteView.h"
#import "WPNetworkingManager.h"
#import "UIExtensions.h"

@interface WPPromoteView ()

@property (nonatomic) UIActivityIndicatorView *indicatorView;

@end

@implementation WPPromoteView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame visibleNavbar:YES];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubviews];
    }
    
    return self;
}

#pragma mark - Public Methods

- (void)stopIndicator {
    [self.indicatorView stopAnimating];
    self.indicatorView.alpha = 0;
}

- (void)createSubviews {

    _userTableView = [({
        UITableView *tableView = [[UITableView alloc] init];
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        tableView;
    }) wp_addToSuperview:self];
    
    _indicatorView = [({
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [view startAnimating];
        view;
    }) wp_addToSuperview:self];
}

- (void)updateConstraints {
    
    [self.userTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [self.indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).with.offset(topMargin + 2 * standardMargin); // For some reason topMargin in equalTo doesn't work...
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [super updateConstraints];
}


@end
