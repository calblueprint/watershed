//
//  WPAddFieldReportView.m
//  Watershed
//
//  Created by Jordeen Chang on 10/29/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPAddFieldReportView.h"
#import "UIExtensions.h"
#import "WPAddFieldReportViewController.h"
#import "FontAwesomeKit/FontAwesomeKit.h"
#import "UIImage+ImageEffects.h"


@interface WPAddFieldReportView()

@property (nonatomic) WPAddFieldReportViewController *parentFieldReportViewController;
@property (nonatomic) UILabel *descriptionLabel;
@property (nonatomic) UILabel *urgentLabel;
@property (nonatomic) UILabel *ratingLabel;
@property (nonatomic) UIView *blackOverlay;

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
    _selectedImageView = [({
        _originalImage = [UIImage imageNamed:@"SampleCoverPhoto"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:_originalImage];
        imageView;
    }) wp_addToSuperview:self];
    
    _blackOverlay = [({
        UIView *blackOverlay = [[UIView alloc] init];
        blackOverlay.backgroundColor = [UIColor blackColor];
        blackOverlay.alpha = 0.3;
        blackOverlay;
    }) wp_addToSuperview:self];

    _urgentLabel = [({
        UILabel *urgentLabel = [[UILabel alloc] init];
        urgentLabel.text = @"Urgent?";
        urgentLabel.textColor = [UIColor whiteColor];
        urgentLabel;
    }) wp_addToSuperview:self];
    
    _urgentSwitch = [({
        UISwitch *urgent = [[UISwitch alloc] init];
        urgent;
    }) wp_addToSuperview:self];
    
    _ratingLabel = [({
        UILabel *ratingLabel = [[UILabel alloc] init];
        ratingLabel.text = @"Rating";
        ratingLabel.textColor = [UIColor whiteColor];
        ratingLabel;
    }) wp_addToSuperview:self];
    
    _rating1 = [({
        UIButton *rating1 = [[UIButton alloc] init];
        rating1.layer.borderColor = [UIColor wp_red].CGColor;
        rating1.layer.borderWidth = wpBorderWidth;
        rating1.layer.cornerRadius = 20;
        rating1.layer.backgroundColor = [UIColor clearColor].CGColor;
        rating1;
    }) wp_addToSuperview:self];
    
    _rating2 = [({
        UIButton *rating2 = [[UIButton alloc] init];
        rating2.layer.borderColor = [UIColor wp_orange].CGColor;
        rating2.layer.borderWidth = wpBorderWidth;
        rating2.layer.cornerRadius = 20;
        rating2.layer.backgroundColor = [UIColor clearColor].CGColor;
        rating2;
    }) wp_addToSuperview:self];
    
    _rating3 = [({
        UIButton *rating3 = [[UIButton alloc] init];
        rating3.layer.borderColor = [UIColor wp_yellow].CGColor;
        rating3.layer.borderWidth = wpBorderWidth;
        rating3.layer.cornerRadius = 20;
        rating3.layer.backgroundColor = [UIColor clearColor].CGColor;
        rating3;
    }) wp_addToSuperview:self];
    
    _rating4 = [({
        UIButton *rating4 = [[UIButton alloc] init];
        rating4.layer.borderColor = [UIColor wp_lime].CGColor;
        rating4.layer.borderWidth = wpBorderWidth;
        rating4.layer.cornerRadius = 20;
        rating4.layer.backgroundColor = [UIColor clearColor].CGColor;
        rating4;
    }) wp_addToSuperview:self];
    
    _rating5 = [({
        UIButton *rating5 = [[UIButton alloc] init];
        rating5.layer.borderColor = [UIColor wp_lightGreen].CGColor;
        rating5.layer.borderWidth = wpBorderWidth;
        rating5.layer.cornerRadius = 20;
        rating5.layer.backgroundColor = [UIColor clearColor].CGColor;
        rating5;
    }) wp_addToSuperview:self];

    _descriptionLabel = [({
        UILabel *descriptionLabel = [[UILabel alloc] init];
        descriptionLabel.text = @"Description";
        descriptionLabel.textColor = [UIColor whiteColor];
        descriptionLabel;
    }) wp_addToSuperview:self];
    
    _fieldDescription = [({
        UITextView *field = [[UITextView alloc] init];
        field.layer.borderColor = [UIColor grayColor].CGColor;
        field.layer.borderWidth = wpBorderWidth;
        field.textColor = [UIColor whiteColor];
        field.backgroundColor = [UIColor clearColor];
        field.layer.cornerRadius = wpCornerRadius;
        field.font = [UIFont systemFontOfSize:14.0];
        field;
    }) wp_addToSuperview:self];

    _addPhotoButton = [({
        UIButton *addPhoto = [[UIButton alloc] init];
        addPhoto.layer.backgroundColor = [UIColor wp_transDarkBlue].CGColor;
        addPhoto.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        addPhoto;
    }) wp_addToSuperview:self];
    
    _viewImageButton = [({
        UIButton *addPhoto = [[UIButton alloc] init];
        addPhoto.layer.backgroundColor = [UIColor wp_transBlue].CGColor;
        addPhoto.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        addPhoto;
    }) wp_addToSuperview:self];
}

- (void)setUpActions {
    [_addPhotoButton setTitle:@"Add Picture" forState:UIControlStateNormal];
    [_addPhotoButton setTitleColor:[UIColor wp_lightBlue] forState: UIControlStateNormal];
    [_viewImageButton setTitle:@"View Image" forState:UIControlStateNormal];
    [_viewImageButton setTitleColor:[UIColor wp_lightBlue] forState: UIControlStateNormal];
    [_ratingField setKeyboardType:UIKeyboardTypeNumberPad];
    [_urgentSwitch setOnTintColor:[UIColor wp_red]];
    _blurredImage = [_originalImage applyBlurWithRadius:5 tintColor:[UIColor clearColor] saturationDeltaFactor:1 maskImage:nil];
    _selectedImageView.image = _blurredImage;
    [self setUpButtons];
}
- (void)setUpButtons {
    [_rating1 setTitle:@"1" forState:UIControlStateNormal];
    [_rating2 setTitle:@"2" forState:UIControlStateNormal];
    [_rating3 setTitle:@"3" forState:UIControlStateNormal];
    [_rating4 setTitle:@"4" forState:UIControlStateNormal];
    [_rating5 setTitle:@"5" forState:UIControlStateNormal];
    [_rating1.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_rating2.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_rating3.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_rating4.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_rating5.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_rating1 setBackgroundColor:[UIColor clearColor]];
    [_rating2 setBackgroundColor:[UIColor clearColor]];
    [_rating3 setBackgroundColor:[UIColor clearColor]];
    [_rating4 setBackgroundColor:[UIColor clearColor]];
    [_rating5 setBackgroundColor:[UIColor clearColor]];
    [_rating1 setTitleColor:[UIColor wp_red] forState: UIControlStateNormal];
    [_rating2 setTitleColor:[UIColor wp_orange] forState: UIControlStateNormal];
    [_rating3 setTitleColor:[UIColor wp_yellow] forState: UIControlStateNormal];
    [_rating4 setTitleColor:[UIColor wp_lime] forState: UIControlStateNormal];
    [_rating5 setTitleColor:[UIColor wp_lightGreen] forState: UIControlStateNormal];
    [_rating1.layer setBorderWidth:wpBorderWidth];
    [_rating2.layer setBorderWidth:wpBorderWidth];
    [_rating3.layer setBorderWidth:wpBorderWidth];
    [_rating4.layer setBorderWidth:wpBorderWidth];
    [_rating5.layer setBorderWidth:wpBorderWidth];
    [_rating1 addTarget:self action:@selector(ratingClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rating2 addTarget:self action:@selector(ratingClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rating3 addTarget:self action:@selector(ratingClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rating4 addTarget:self action:@selector(ratingClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rating5 addTarget:self action:@selector(ratingClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)ratingClick:(UIButton *)sender {
    int senderBorder = sender.layer.borderWidth;
    [self setUpButtons];
    if (senderBorder == 1) {
        sender.backgroundColor = sender.titleLabel.textColor;
        [sender setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
        sender.layer.borderWidth = 0;
    }
}

- (void)updateConstraints {
    [self.urgentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin + standardMargin * 2));
        make.leading.equalTo(@(standardMargin));
    }];
    
    [self.urgentSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin + standardMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];
    [self.ratingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.urgentSwitch.mas_bottom).with.offset(standardMargin * 1.5);
        make.leading.equalTo(@(standardMargin));
    }];

    [self.rating1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.urgentSwitch.mas_bottom).with.offset(standardMargin);
        make.leading.equalTo(self.ratingLabel.mas_right).with.offset(10);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    
    [self.rating2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.urgentSwitch.mas_bottom).with.offset(standardMargin);
        make.leading.equalTo(self.rating1.mas_right).with.offset(10);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];

    [self.rating3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.urgentSwitch.mas_bottom).with.offset(standardMargin);
        make.leading.equalTo(self.rating2.mas_right).with.offset(10);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    
    [self.rating4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.urgentSwitch.mas_bottom).with.offset(standardMargin);
        make.leading.equalTo(self.rating3.mas_right).with.offset(10);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    
    [self.rating5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.urgentSwitch.mas_bottom).with.offset(standardMargin);
        make.leading.equalTo(self.rating4.mas_right).with.offset(10);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rating5.mas_bottom).with.offset(standardMargin);
        make.leading.equalTo(@(standardMargin));
    }];
    
    [self.fieldDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionLabel.mas_bottom).with.offset(standardMargin);
        make.centerX.equalTo(self.mas_centerX);
        make.leading.equalTo(@10);
        make.trailing.equalTo(@(-10));
        make.bottom.equalTo(self.addPhotoButton.mas_top).with.offset(-standardMargin);
    }];
    
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.bottom.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];

    [self.addPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.height.equalTo(@150);
        make.leading.equalTo(@0);
        make.trailing.equalTo(self.mas_centerX);
    }];
    
    [self.viewImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.leading.equalTo(self.addPhotoButton.mas_right);
        make.height.equalTo(@150);
        make.trailing.equalTo(@0);
        
    }];
    
    [self.blackOverlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [super updateConstraints];
}

@end
