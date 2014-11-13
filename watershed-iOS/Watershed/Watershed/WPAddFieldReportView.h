//
//  WPAddFieldReportView.h
//  Watershed
//
//  Created by Jordeen Chang on 10/29/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPAddPhotoViewController.h"
#import "UIExtensions.h"
#import "WPAddFieldReportViewController.h"


@interface WPAddFieldReportView : WPView

@property (nonatomic) UITextView *fieldDescription;
@property (nonatomic) UIPickerView *healthRating;
@property (nonatomic) UISwitch *urgentSwitch;
@property (nonatomic) UIButton *addPhotoButton;
@property (nonatomic) UIPickerView *healthRatingPicker;
@property (nonatomic) UITextField *ratingField;
@property (nonatomic) UIImageView *selectedImageView;
@property (nonatomic) UIButton *rating1;
@property (nonatomic) UIButton *rating2;
@property (nonatomic) UIButton *rating3;
@property (nonatomic) UIButton *rating4;
@property (nonatomic) UIButton *rating5;

@end
