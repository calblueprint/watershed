//
//  UIView+WPExtensions.h
//  Watershed
//
//  Created by Jordeen Chang on 9/28/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WPExtensions)

- (instancetype)wp_addToSuperview:(UIView *)view;

+ (NSNumber *)wp_stylePadding;
+ (NSNumber *)wp_styleNegativePadding;

@end
