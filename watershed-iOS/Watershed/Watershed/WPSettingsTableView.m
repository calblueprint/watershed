//
//  WPSettingsTableView.m
//  Watershed
//
//  Created by Andrew on 11/1/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSettingsTableView.h"
#import "Masonry.h"

@interface WPSettingsTableView ()

@property (nonatomic) UIView *footer;
@property (nonatomic) UILabel *twp;
@property (nonatomic) UILabel *bp;
@property (nonatomic) UIImageView *paw;

@end

@implementation WPSettingsTableView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubviews];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)createSubviews {
    _footer = [[UIView alloc] init];
    _twp = [[UILabel alloc] init];
    _twp.text = @"The Watershed Project \u00A9 2014";
    _twp.font = [UIFont fontWithName:@"Helvetica" size:10];
    
    _bp = [[UILabel alloc] init];
    _bp.text = @"Created by Cal Blueprint";
    _bp.font = [UIFont fontWithName:@"Helvetica" size:10];
    
    _paw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paw.png"]];
    _paw.clipsToBounds = YES;
    _paw.contentMode = UIViewContentModeScaleAspectFit;
    
    [_footer addSubview:_twp];
    [_footer addSubview:_bp];
    [_footer addSubview:_paw];
    
    self.tableFooterView = _footer;
    
}

- (void)updateConstraints {
    [_twp mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.centerX.equalTo(@0);
        make.height.equalTo(@20);
    }];
    
    [_bp mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.twp.mas_bottom);
        make.centerX.equalTo(@0);
        make.height.equalTo(@20);
    }];
    
    [_paw mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bp.mas_top);
        make.bottom.equalTo(self.bp.mas_bottom);
        make.centerX.equalTo(self.bp.mas_centerX).with.offset(70);
    }];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@64);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [super updateConstraints];
}

@end
