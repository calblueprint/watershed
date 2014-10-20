//
//  WPLabeledIcon.h
//  Watershed
//
//  Created by Andrew on 10/12/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPLabeledIcon : UILabel

@property (nonatomic) UILabel *label;
@property (nonatomic) UIImageView *iconView;

- (id)initWithText:(NSString *)text
              icon:(UIImage *)icon;

+ (NSInteger)viewHeight;

@end
