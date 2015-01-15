//
//  WPAddVegetationTableViewCell.h
//  Watershed
//
//  Created by Andrew Millman on 1/14/15.
//  Copyright (c) 2015 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIExtensions.h"

@interface WPAddVegetationTableViewCell : UITableViewCell

@property (nonatomic) UITextField *textField;
@property (nonatomic) UIButton *addButton;

+ (CGFloat)cellHeight;
@end
