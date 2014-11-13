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
#import "FontAwesomeKit/FontAwesomeKit.h"

@interface WPAddFieldReportView()

@property (nonatomic) WPAddFieldReportViewController *parentFieldReportViewController;
@property (nonatomic) UILabel *descriptionLabel;
@property (nonatomic) UILabel *urgentLabel;
@property (nonatomic) UILabel *ratingLabel;

@end

@implementation WPAddFieldReportView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame visibleNavbar:YES];
    if (self) {
        [self createSubviews];
        [self updateConstraints];
        [self setUpActions];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andPickerViewController: (WPAddFieldReportViewController *)parentViewController {
    self = [super initWithFrame:frame visibleNavbar:YES];
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
        urgentLabel.textColor = [UIColor wp_blue];
        urgentLabel;
    }) wp_addToSuperview:self];
    
    _urgentSwitch = [({
        UISwitch *urgent = [[UISwitch alloc] init];
        urgent;
    }) wp_addToSuperview:self];
    
    _ratingLabel = [({
        UILabel *ratingLabel = [[UILabel alloc] init];
        ratingLabel.text = @"Rating";
        ratingLabel.textColor = [UIColor wp_blue];
        ratingLabel;
    }) wp_addToSuperview:self];
    
    _ratingField = [({
        UITextField *rating = [[UITextField alloc] init];
        rating.placeholder = @"1-5";
        rating;
    }) wp_addToSuperview:self];
    
    _descriptionLabel = [({
        UILabel *descriptionLabel = [[UILabel alloc] init];
        descriptionLabel.text = @"Description";
        descriptionLabel.textColor = [UIColor wp_blue];
        descriptionLabel;
    }) wp_addToSuperview:self];
    
    _fieldDescription = [({
        UITextView *field = [[UITextView alloc] init];
        field.layer.borderColor = [UIColor wp_blue].CGColor;
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
//        FAKIonIcons *photoIcon = [FAKIonIcons ios7PhotosIconWithSize:30];
//        [addPhoto setImage:[[UIImageView alloc] initWithImage:[photoIcon imageWithSize:CGSizeMake(30,30)]] forState:UIControlStateNormal];
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
    [_addPhotoButton setTitle:@"Add Picture" forState:UIControlStateNormal];
    [_addPhotoButton setTitleColor:[UIColor wp_darkBlue] forState: UIControlStateNormal];
    [_ratingField setKeyboardType:UIKeyboardTypeNumberPad];
    [_urgentSwitch setOnTintColor:[UIColor redColor]];

}

- (void)updateConstraints {
    [self.urgentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.leading.equalTo(@(standardMargin));
    }];
    
    [self.urgentSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];
    [self.ratingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.urgentSwitch.mas_bottom).with.offset(standardMargin);
        make.leading.equalTo(@(standardMargin));
    }];
    
    [self.ratingField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.urgentSwitch.mas_bottom).with.offset(standardMargin);
        make.trailing.equalTo(@(-standardMargin));
    }];
    
    [self.healthRating mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fieldDescription.mas_bottom).with.offset(standardMargin);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@(wpButtonHeight));
        make.width.equalTo(@(wpButtonWidth));
    }];


    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ratingLabel.mas_bottom).with.offset(standardMargin);
        make.leading.equalTo(@(standardMargin));
    }];
    
    [self.fieldDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).with.offset(standardMargin);
        make.centerX.equalTo(self.mas_centerX);
        make.leading.equalTo(@10);
        make.trailing.equalTo(@(-10));
        make.height.equalTo(@150);
    }];
    
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addPhotoButton.mas_bottom).with.offset(standardMargin);
        make.bottom.equalTo(@(-standardMargin));
//        make.left.equalTo(self.addPhotoButton.mas_right).with.offset(standardMargin);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];
    
    [self.addPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fieldDescription.mas_bottom).with.offset(standardMargin);
//        make.bottom.equalTo(@(-60));
        make.centerX.equalTo(self.mas_centerX);
//        make.leading.equalTo(@(standardMargin));
        make.height.equalTo(@(wpButtonHeight));
        make.width.equalTo(@(wpButtonWidth));
    }];
    
    [super updateConstraints];
}

@end
