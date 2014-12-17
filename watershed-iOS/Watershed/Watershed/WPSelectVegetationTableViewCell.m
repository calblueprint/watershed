//
//  WPSelectVegetationTableViewCell.m
//  Watershed
//
//  Created by Andrew Millman on 12/15/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSelectVegetationTableViewCell.h"

@interface WPSelectVegetationTableViewCell ()
@property (nonatomic) UIView *radioButton;
@end

@implementation WPSelectVegetationTableViewCell

const static float CELL_HEIGHT = 50.0f;
const static float RADIO_BUTTON_SIZE = 25.0f;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
        [self updateConstraints];
    }
    return self;
}

- (void)createSubviews {
    _radioButton = [({
        UIView *button = [[UIView alloc] init];
        button.layer.cornerRadius = RADIO_BUTTON_SIZE / 2;
        button.clipsToBounds = YES;
        button.layer.borderColor = [UIColor grayColor].CGColor;
        button.backgroundColor = [UIColor grayColor];
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
    
    [self.radioButton mas_updateConstraints:^(MASConstraintMaker *make) {
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (!self.isActive && selected) {
        self.backgroundColor = [UIColor wp_lightBlue];
        self.textLabel.textColor = [UIColor whiteColor];
        self.active = YES;
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundColor = [UIColor clearColor];
            self.textLabel.textColor = [UIColor blackColor];
        }];
        self.active = NO;
    }
}


@end
