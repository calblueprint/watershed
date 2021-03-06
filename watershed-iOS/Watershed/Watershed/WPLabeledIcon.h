//
//  WPLabeledIcon.h
//  Watershed
//
//  Created by Andrew Millman on 10/12/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPView.h"

@interface WPLabeledIcon : UILabel

@property (nonatomic) UILabel *label;
@property (nonatomic) UIImageView *iconView;

- (id)initWithText:(NSString *)text
              icon:(UIImage *)icon;

+ (NSInteger)viewHeight;

@end
