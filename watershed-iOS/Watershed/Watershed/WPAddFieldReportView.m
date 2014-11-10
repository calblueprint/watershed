//
//  WPAddFieldReportView.m
//  Watershed
//
//  Created by Jordeen Chang on 10/29/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPAddFieldReportView.h"
#import "UIExtensions.h"

@implementation WPAddFieldReportView


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
    
    _fieldDescription = [({
        UITextField *field = [[UITextField alloc] init];
        field.layer.borderColor = [UIColor wp_blue].CGColor;
        field.layer.borderWidth = wpBorderWidth;
        field.layer.cornerRadius = wpCornerRadius;
        field;
    }) wp_addToSuperview:self];
    
    _healthRating = [({
        UIPickerView *health = [[UIPickerView alloc] init];
        health.layer.borderWidth = wpBorderWidth;
        health.layer.cornerRadius = wpCornerRadius;
        health;
    }) wp_addToSuperview:self];

    _addPhotoButton = [({
        UIButton *addPhoto = [[UIButton alloc] init];
        addPhoto.layer.borderColor = [UIColor wp_blue].CGColor;
        addPhoto.layer.borderWidth = wpBorderWidth;
        addPhoto.layer.cornerRadius = wpCornerRadius;
        addPhoto.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        addPhoto.titleLabel.text = @"Select From Photos";
        addPhoto.titleLabel.textColor = [UIColor wp_blue];
        addPhoto;
    }) wp_addToSuperview:self];

}

- (void)setUpActions {
    [_addPhotoButton setTitle:@"Take Picture" forState:UIControlStateNormal];
    [_addPhotoButton setTitleColor:[UIColor wp_darkBlue] forState: UIControlStateNormal];
}

- (void)updateConstraints {
    [self.fieldDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.height.equalTo(@50);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];
    
    [self.healthRating mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fieldDescription.mas_bottom).with.offset(-standardMargin);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(wpButtonHeight));
        make.width.equalTo(@(wpButtonWidth));
    }];
    
    [self.addPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self.takePhotoButton.mas_bottom).with.offset(standardMargin);
        make.bottom.equalTo(@(-60));
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(wpButtonHeight));
        make.width.equalTo(@(wpButtonWidth));
    }];
    
    [super updateConstraints];
}

@end
