//
//  WPCreateMiniSiteImageTableViewCell.h
//  Watershed
//
//  Created by Andrew Millman on 12/11/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIExtensions.h"

@interface WPCreateMiniSiteImageTableViewCell : UITableViewCell

@property (nonatomic) UILabel *inputLabel;
@property (nonatomic) UIImageView *imageInputView;
@property (nonatomic) UIButton *viewImageButton;

+ (CGFloat)cellHeight;

@end
