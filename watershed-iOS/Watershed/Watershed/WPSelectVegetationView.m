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

const static float TEXT_FIELD_HEIGHT = 54.0f;

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
    
    _addVegetationTextField = [({
        WPAddVegetationTextField *field = [[WPAddVegetationTextField alloc] init];
        field;
    }) wp_addToSuperview:self];
    
    _selectVegetationTableView = [({
        UITableView *selectVegetationTableView = [[UITableView alloc] init];
        [selectVegetationTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        selectVegetationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    [self.addVegetationTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.equalTo(@(TEXT_FIELD_HEIGHT));
    }];
    
    [self.selectVegetationTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addVegetationTextField.mas_bottom);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
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
