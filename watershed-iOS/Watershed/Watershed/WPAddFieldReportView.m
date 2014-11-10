//
//  WPAddFieldReportView.m
//  Watershed
//
//  Created by Jordeen Chang on 10/29/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPAddFieldReportView.h"
#import "WPHealthPickerViewController.h"
#import "UIExtensions.h"
#import "WPAddFieldReportViewController.h"

@interface WPAddFieldReportView()

@property (nonatomic) WPAddFieldReportViewController *parentFieldReportViewController;
@property (nonatomic) UILabel *descriptionLabel;
@property (nonatomic) UILabel *urgentLabel;
@property (nonatomic) UILabel *ratingLabel;

@end

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


- (instancetype)initWithFrame:(CGRect)frame andPickerViewController: (WPAddFieldReportViewController *)parentViewController {
    self = [super init];
    self.parentFieldReportViewController = parentViewController;
    if (self) {
        [self createSubviews];
        [self updateConstraints];
        [self setUpActions];
    }
    return self;
}
- (void)createSubviews {

    _urgentLabel = [({
        UILabel *urgentLabel = [[UILabel alloc] init];
        urgentLabel.text = @"Urgent?";
        urgentLabel;
    }) wp_addToSuperview:self];
    
    _urgent = [({
        UISwitch *urgent = [[UISwitch alloc] init];
        urgent;
    }) wp_addToSuperview:self];
    
    _ratingLabel = [({
        UILabel *ratingLabel = [[UILabel alloc] init];
        ratingLabel.text = @"Rating";
        ratingLabel;
    }) wp_addToSuperview:self];
    
    _ratingField = [({
        UITextField *rating = [[UITextField alloc] init];
        rating.placeholder = @"Select";
        rating;
    }) wp_addToSuperview:self];
    
    _descriptionLabel = [({
        UILabel *descriptionLabel = [[UILabel alloc] init];
        descriptionLabel.text = @"Description";
        descriptionLabel;
    }) wp_addToSuperview:self];
    
    _fieldDescription = [({
        UITextView *field = [[UITextView alloc] init];
        field.layer.borderColor = [UIColor grayColor].CGColor;
        field.layer.borderWidth = wpBorderWidth;
        field.layer.cornerRadius = wpCornerRadius;
        field;
    }) wp_addToSuperview:self];
    
//    _healthRating = [({
//        UIPickerView *health = _parentFieldReportViewController.healthPickerController.healthRatingPicker;
//        health;
//    }) wp_addToSuperview:self];

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
    
    _selectedImageView = [({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.borderColor = [UIColor wp_blue].CGColor;
        imageView.layer.borderWidth = wpBorderWidth;
        imageView.layer.cornerRadius = wpCornerRadius;
        imageView;
    }) wp_addToSuperview:self];

}

- (void)setUpActions {
    [_addPhotoButton setTitle:@"Take Picture" forState:UIControlStateNormal];
    [_addPhotoButton setTitleColor:[UIColor wp_darkBlue] forState: UIControlStateNormal];
}

- (void)updateConstraints {
    [self.urgentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.leading.equalTo(@(standardMargin));
    }];
    
    [self.urgent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];
    [self.ratingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.urgentLabel.mas_bottom).with.offset(standardMargin);
        make.leading.equalTo(@(standardMargin));
    }];
    
    [self.ratingField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.urgentLabel.mas_bottom).with.offset(standardMargin);
        make.trailing.equalTo(@(-standardMargin));
    }];

    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ratingLabel.mas_bottom).with.offset(standardMargin);
        make.leading.equalTo(@(standardMargin));
    }];
    
    [self.fieldDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).with.offset(standardMargin);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(wpButtonWidth));
        make.height.equalTo(@200);
    }];
    
//    [self.healthRating mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.fieldDescription.mas_bottom).with.offset(standardMargin);
//        make.centerX.equalTo(self.mas_centerX);
//        make.height.equalTo(@(wpButtonHeight));
//        make.width.equalTo(@(wpButtonWidth));
//    }];
    
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fieldDescription.mas_bottom).with.offset(standardMargin);
        make.bottom.equalTo(@(-standardMargin));
        make.left.equalTo(self.addPhotoButton.mas_right).with.offset(standardMargin);
        make.trailing.equalTo(@(-standardMargin));
    }];
    
    [self.addPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self.takePhotoButton.mas_bottom).with.offset(standardMargin);
        make.bottom.equalTo(@(-60));
        make.leading.equalTo(@(standardMargin));
        make.height.equalTo(@(wpButtonHeight));
        make.width.equalTo(@50);
    }];
    
    [super updateConstraints];
}

@end
