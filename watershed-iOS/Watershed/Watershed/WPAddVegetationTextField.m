//
//  WPAddVegetationTableViewCell.m
//  Watershed
//
//  Created by Andrew Millman on 1/14/15.
//  Copyright (c) 2015 Blueprint. All rights reserved.
//

#import "WPAddVegetationTextField.h"

@interface WPAddVegetationTextField ()

@end

@implementation WPAddVegetationTextField

const static float CELL_HEIGHT = 60.0f;
const static float RADIO_BUTTON_SIZE = 30.0f;
const static float CHECK_SIZE = RADIO_BUTTON_SIZE * 3 / 4;

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
        [self updateConstraints];
    }
    return self;
}

- (void)createSubviews {
    _addButton = [({
        UIButton *button = [[UIButton alloc] init];
        button.layer.cornerRadius = RADIO_BUTTON_SIZE / 2;
        button.clipsToBounds = YES;
        button.backgroundColor = [UIColor wp_green];
        
        FAKIonIcons *checkIcon = [FAKIonIcons androidDoneIconWithSize:CHECK_SIZE];
        UIImage *checkImage = [checkIcon imageWithSize:CGSizeMake(CHECK_SIZE, CHECK_SIZE)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:checkImage];
        [imageView setFrame:CGRectMake((RADIO_BUTTON_SIZE - CHECK_SIZE) / 2, (RADIO_BUTTON_SIZE - CHECK_SIZE) / 2, CHECK_SIZE, CHECK_SIZE)];
        [button addSubview:imageView];
        
        button;
    }) wp_addToSuperview:self];
    
}

- (void)updateConstraints {
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.addButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-standardMargin));
        make.width.equalTo(@(RADIO_BUTTON_SIZE));
        make.height.equalTo(@(RADIO_BUTTON_SIZE));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [super updateConstraints];
}

#pragma mark - Public Methods

+ (CGFloat)cellHeight {
    return CELL_HEIGHT;
}

@end
