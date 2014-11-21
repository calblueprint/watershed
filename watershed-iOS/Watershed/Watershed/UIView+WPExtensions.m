//
//  UIView+WPExtensions.m
//  Watershed
//
//  Created by Jordeen Chang on 9/28/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "UIView+WPExtensions.h"

@implementation UIView (WPExtensions)

- (instancetype)wp_addToSuperview:(UIView *)view {
    // Add some check to make sure view is not nil
    [view addSubview:self];
    return self;
}

+ (NSNumber *)wp_stylePadding { return @10; }
+ (NSNumber *)wp_styleMorePadding { return @15; }
+ (NSNumber *)wp_styleNegativePadding { return [[NSNumber alloc] initWithFloat: -1.0 * [[UIView wp_stylePadding] floatValue]]; }
+ (NSNumber *)wp_styleMoreNegativePadding { return [[NSNumber alloc] initWithFloat: -1.0 * [[UIView wp_styleMorePadding] floatValue]]; }

@end
