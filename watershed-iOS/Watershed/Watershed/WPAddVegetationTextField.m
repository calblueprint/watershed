//
//  WPAddVegetationTextField.m
//  Watershed
//
//  Created by Andrew Millman on 1/14/15.
//  Copyright (c) 2015 Blueprint. All rights reserved.
//

#import "WPAddVegetationTextField.h"

@interface WPAddVegetationTextField ()
@property (nonatomic) UIView *separatorView;
@end

@implementation WPAddVegetationTextField

const static float RADIO_BUTTON_SIZE = 30.0f;
const static float PLUS_SIZE = RADIO_BUTTON_SIZE * 3 / 4;

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubviews];
        [self updateConstraints];
    }
    return self;
}

- (void)createSubviews {
    
    _textField = [({
        UITextField *field = [[UITextField alloc] init];
        field.placeholder = @"Add...";
        field.font = [UIFont systemFontOfSize:13.0];
        field;
    }) wp_addToSuperview:self];
    
    _addButton = [({
        UIButton *button = [[UIButton alloc] init];
        button.layer.cornerRadius = RADIO_BUTTON_SIZE / 2;
        button.clipsToBounds = YES;
        button.backgroundColor = [UIColor wp_lightGreen];
        
        FAKIonIcons *plusIcon = [FAKIonIcons androidAddIconWithSize:PLUS_SIZE];
        [plusIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        UIImage *plusImage = [plusIcon imageWithSize:CGSizeMake(PLUS_SIZE, PLUS_SIZE)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:plusImage];
        [imageView setFrame:CGRectMake((RADIO_BUTTON_SIZE - PLUS_SIZE) / 2, (RADIO_BUTTON_SIZE - PLUS_SIZE) / 2, PLUS_SIZE, PLUS_SIZE)];
        [button addSubview:imageView];
        
        button;
    }) wp_addToSuperview:self];
    
    _separatorView = [({
        UIView *separator = [[UIView alloc] init];
        separator.backgroundColor = [UIColor grayColor];
        separator.alpha = 0.3;
        separator;
    }) wp_addToSuperview:self];
}

- (void)updateConstraints {
    
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.trailing.equalTo(self.addButton.mas_leading).with.offset(-standardMargin);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [self.addButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-standardMargin));
        make.width.equalTo(@(RADIO_BUTTON_SIZE));
        make.height.equalTo(@(RADIO_BUTTON_SIZE));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.separatorView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(0.5));
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [super updateConstraints];
}

@end
