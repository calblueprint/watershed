//
//  WPCreateMiniSiteTableViewCell.h
//  Watershed
//
//  Created by Andrew Millman on 12/11/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIExtensions.h"

@interface WPCreateMiniSiteTableViewCell : UITableViewCell

@property (nonatomic) UILabel *inputLabel;
@property (nonatomic) UIView *textInput;

+ (CGFloat)cellHeight;
+ (CGFloat)cellDescriptionHeight;

@end
