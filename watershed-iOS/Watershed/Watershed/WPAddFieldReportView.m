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

int WPRatingButtonHeight = 40;
int WPPhotoButtonHeight = 75;
int highestRating = 5;

@interface WPAddFieldReportView()

@property (nonatomic) WPAddFieldReportViewController *parentFieldReportViewController;
@property (nonatomic) UILabel *descriptionLabel;
@property (nonatomic) UILabel *urgentLabel;
@property (nonatomic) UILabel *ratingLabel;
@property (nonatomic) UIView *blackOverlay;
@property (nonatomic) NSMutableArray *ratingButtonArray;

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

- (instancetype)initWithFrame:(CGRect)frame
      andPickerViewController: (WPAddFieldReportViewController *)parentViewController {
    self = [super initWithFrame:frame visibleNavbar:YES];
    if (self) {
        self.parentFieldReportViewController = parentViewController;
        [self createSubviews];
        [self updateConstraints];
        [self setUpActions];
    }
    [self setBackgroundColor:[UIColor whiteColor]];
    return self;
}
- (void)createSubviews {
    _fieldReportTableView = [({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        tableView;
    }) wp_addToSuperview:self];
    
    _selectedImageView = [({
//        _originalImage = [UIImage imageNamed:@"SampleCoverPhoto"];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:_originalImage];
        UIImageView *imageView = [[UIImageView alloc] init];
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

    _rating1 = [[UIButton alloc] init];
    _rating2 = [[UIButton alloc] init];
    _rating3 = [[UIButton alloc] init];
    _rating4 = [[UIButton alloc] init];
    _rating5 = [[UIButton alloc] init];

    _ratingButtonArray = [[NSMutableArray alloc] initWithObjects:_rating1, _rating2, _rating3, _rating4, _rating5, nil];

    for (int i = 0; i < highestRating; i++)
    {
        UIButton *currButton = _ratingButtonArray[i];
        currButton.layer.borderWidth = wpBorderWidth;
        currButton.layer.borderColor = [UIColor wp_red].CGColor;
        currButton.layer.cornerRadius = WPRatingButtonHeight/2;
        currButton.layer.backgroundColor = [UIColor clearColor].CGColor;
        [currButton wp_addToSuperview:self];
    }
    
    _rating1.layer.borderColor = [UIColor wp_red].CGColor;
    _rating2.layer.borderColor = [UIColor wp_orange].CGColor;
    _rating3.layer.borderColor = [UIColor wp_yellow].CGColor;
    _rating4.layer.borderColor = [UIColor wp_lime].CGColor;
    _rating5.layer.borderColor = [UIColor wp_lightGreen].CGColor;
    
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
        addPhoto.layer.backgroundColor = [UIColor wp_transparentDarkBlue].CGColor;
        addPhoto.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        addPhoto;
    }) wp_addToSuperview:self];
    
    _viewImageButton = [({
        UIButton *addPhoto = [[UIButton alloc] init];
        addPhoto.layer.backgroundColor = [UIColor wp_transparentBlue].CGColor;
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
    [self setUpButtons];
}

- (void)setUpButtons {
    for (int i = 0; i < highestRating; i++)
    {
        UIButton *currButton = _ratingButtonArray[i];
        NSString* title = [NSString stringWithFormat:@"%i", i + 1];
        [currButton setTitle:title forState:UIControlStateNormal];
        [currButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [currButton setBackgroundColor:[UIColor clearColor]];
        [currButton.layer setBorderWidth:wpBorderWidth];
        [currButton addTarget:self action:@selector(ratingClick:) forControlEvents:UIControlEventTouchUpInside];
        [currButton setTitleColor:[UIColor whiteColor] forState: UIControlStateSelected];
        currButton.selected = NO;
    }

    [_rating1 setTitleColor:[UIColor wp_red] forState: UIControlStateNormal];
    [_rating2 setTitleColor:[UIColor wp_orange] forState: UIControlStateNormal];
    [_rating3 setTitleColor:[UIColor wp_yellow] forState: UIControlStateNormal];
    [_rating4 setTitleColor:[UIColor wp_lime] forState: UIControlStateNormal];
    [_rating5 setTitleColor:[UIColor wp_lightGreen] forState: UIControlStateNormal];
    
}

-(void)ratingClick:(UIButton *)sender {
    BOOL isButtonSelected = ![sender isSelected];
    [self setUpButtons];
    sender.selected = isButtonSelected;
    if (isButtonSelected) {
        sender.backgroundColor = sender.titleLabel.textColor;
        sender.layer.borderWidth = 0;
    }
}

- (void)updateConstraints {
    
    [self.fieldReportTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.bottom.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];

//    [self.rating1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.urgentSwitch.mas_bottom).with.offset(standardMargin);
//        make.leading.equalTo(self.ratingLabel.mas_right).with.offset(10);
//        make.height.equalTo(@(WPRatingButtonHeight));
//        make.width.equalTo(@(WPRatingButtonHeight));
//    }];
//    
//    [self.rating2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.urgentSwitch.mas_bottom).with.offset(standardMargin);
//        make.leading.equalTo(self.rating1.mas_right).with.offset(10);
//        make.height.equalTo(@(WPRatingButtonHeight));
//        make.width.equalTo(@(WPRatingButtonHeight));
//    }];
//
//    [self.rating3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.urgentSwitch.mas_bottom).with.offset(standardMargin);
//        make.leading.equalTo(self.rating2.mas_right).with.offset(10);
//        make.height.equalTo(@(WPRatingButtonHeight));
//        make.width.equalTo(@(WPRatingButtonHeight));
//    }];
//    
//    [self.rating4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.urgentSwitch.mas_bottom).with.offset(standardMargin);
//        make.leading.equalTo(self.rating3.mas_right).with.offset(10);
//        make.height.equalTo(@(WPRatingButtonHeight));
//        make.width.equalTo(@(WPRatingButtonHeight));
//    }];
//    
//    [self.rating5 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.urgentSwitch.mas_bottom).with.offset(standardMargin);
//        make.leading.equalTo(self.rating4.mas_right).with.offset(10);
//        make.height.equalTo(@(WPRatingButtonHeight));
//        make.width.equalTo(@(WPRatingButtonHeight));
//    }];
    
    
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.bottom.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];

    [self.addPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.height.equalTo(@(WPPhotoButtonHeight));
        make.leading.equalTo(@0);
        make.trailing.equalTo(self.mas_centerX);
    }];
    
    [self.viewImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.leading.equalTo(self.addPhotoButton.mas_right);
        make.height.equalTo(@(WPPhotoButtonHeight));
        make.trailing.equalTo(@0);
        
    }];
    
//    [self.blackOverlay mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@(topMargin));
//        make.leading.equalTo(@0);
//        make.trailing.equalTo(@0);
//        make.bottom.equalTo(@0);
//    }];
    
    [super updateConstraints];
}

@end
