//
//  WPAddPhotoView.m
//  Watershed
//
//  Created by Jordeen Chang on 11/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPAddPhotoView.h"
#import "UIExtensions.h"

@interface WPAddPhotoView()

@end

@implementation WPAddPhotoView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubviews];
        [self updateConstraints];
        [self setUpActions];
    }
    return self;
}

- (void)createSubviews {

    _takePhotoButton = [({
        UIButton *take = [[UIButton alloc] init];
        take.layer.borderColor = [UIColor wp_blue].CGColor;
        take.layer.borderWidth = wpBorderWidth;
        take.layer.cornerRadius = wpCornerRadius;
        take.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        take;
    }) wp_addToSuperview:self];

    _selectPhotoButton = [({
        UIButton *select = [[UIButton alloc] init];
        select.layer.borderColor = [UIColor wp_blue].CGColor;
        select.layer.borderWidth = wpBorderWidth;
        select.layer.cornerRadius = wpCornerRadius;
        select.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        select.titleLabel.text = @"Select From Photos";
        select.titleLabel.textColor = [UIColor wp_blue];
        select;
    }) wp_addToSuperview:self];
    
    _selectedImageView = [({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.borderColor = [UIColor wp_blue].CGColor;
        imageView.layer.borderWidth = wpBorderWidth;
        imageView.layer.cornerRadius = wpCornerRadius;
        imageView;
    }) wp_addToSuperview:self];
}

- (void)setUpActions {
    [_takePhotoButton setTitle:@"Take Picture" forState:UIControlStateNormal];
    [_takePhotoButton setTitleColor:[UIColor wp_darkBlue] forState: UIControlStateNormal];
    [_selectPhotoButton setTitle:@"Select From Photos" forState:UIControlStateNormal];
    [_selectPhotoButton setTitleColor:[UIColor wp_darkBlue] forState: UIControlStateNormal];
}

- (void)updateConstraints {
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.height.equalTo(@300);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];
    
    [self.takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.selectPhotoButton.mas_top).with.offset(-25);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(wpButtonHeight));
        make.width.equalTo(@(wpButtonWidth));
    }];
    
    [self.selectPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.takePhotoButton.mas_bottom).with.offset(standardMargin);
        make.bottom.equalTo(@(-60));
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(wpButtonHeight));
        make.width.equalTo(@(wpButtonWidth));
    }];
    
    [super updateConstraints];
}




@end
