//
//  WPSelectVegetationView.m
//  Watershed
//
//  Created by Andrew Millman on 12/13/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSelectVegetationView.h"

@interface WPSelectVegetationView ()
@property (nonatomic) UIView *navbarShadowOverlay;
@end

@implementation WPSelectVegetationView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
        [self updateConstraints];
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)createSubviews {
    
    _selectVegetationTableView = [({
        UITableView *selectVegetationTableView = [[UITableView alloc] init];
        [selectVegetationTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        selectVegetationTableView.allowsMultipleSelection = YES;
        selectVegetationTableView;
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
    
    [self.selectVegetationTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
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
