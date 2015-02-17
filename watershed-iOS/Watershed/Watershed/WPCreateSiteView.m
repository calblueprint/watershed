//
//  WPCreateSiteView.m
//  Watershed
//
//  Created by Andrew Millman on 12/2/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPCreateSiteView.h"

@interface WPCreateSiteView ()
@property (nonatomic) UIView *statusBarView;
@property (nonatomic) UIView *navbarShadowOverlay;
@end

@implementation WPCreateSiteView

- (instancetype)init {
    self = [super init];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        [self createSubviews];
        [self setNeedsUpdateConstraints];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createSubviews {
    
    _infoTableView = [({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        tableView;
    }) wp_addToSuperview:self];
    
    _statusBarView = [({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view;
    }) wp_addToSuperview:self];
    
    _navbarShadowOverlay = [({
        UIImageView *navbarShadowOverlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShadowOverlay"]];
        [navbarShadowOverlay setContentMode:UIViewContentModeScaleToFill];
        [navbarShadowOverlay setClipsToBounds:YES];
        navbarShadowOverlay.alpha = 0.10;
        navbarShadowOverlay;
    }) wp_addToSuperview:self];
}

- (void)updateConstraints {
    
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.statusBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.equalTo(@20);
    }];
    
    [self.navbarShadowOverlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.equalTo(@10);
    }];
    
    [super updateConstraints];
}

@end
