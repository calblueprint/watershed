//
//  WPAddFieldReportView.h
//  Watershed
//
//  Created by Jordeen Chang on 10/29/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPAddPhotoViewController.h"


@interface WPAddFieldReportView : UIView

@property (nonatomic) UITextView *fieldDescription;
@property (nonatomic) UIPickerView *healthRating;
@property (nonatomic) UISwitch *urgent;
@property (nonatomic) UIButton *addPhotoButton;

@end
