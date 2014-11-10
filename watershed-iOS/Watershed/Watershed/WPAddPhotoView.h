//
//  WPAddPhotoView.h
//  Watershed
//
//  Created by Jordeen Chang on 11/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPAddPhotoViewController.h"
@class WPAddPhotoViewController;

@interface WPAddPhotoView : UIView
@property (nonatomic) UIButton *takePhotoButton;
@property (nonatomic) UIButton *selectPhotoButton;
@property (nonatomic) UIImageView *selectedImageView;

//- (instancetype)initWithAddPhotoViewController:(WPAddPhotoViewController *)addPhotoViewController;

@end
