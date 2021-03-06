//
//  WPCreateSiteTableViewCell.h
//  Watershed
//
//  Created by Andrew Millman on 12/3/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIExtensions.h"

@interface WPCreateSiteTableViewCell : UITableViewCell

@property (nonatomic) UILabel *inputLabel;
@property (nonatomic) UIView *textInput;

+ (CGFloat)cellHeight;
+ (CGFloat)cellDescriptionHeight;

@end
