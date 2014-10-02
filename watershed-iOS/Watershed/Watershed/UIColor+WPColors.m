//
//  UIColor+WPColors.m
//  Watershed
//
//  Created by Jordeen Chang on 9/28/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "UIColor+WPColors.h"

// In UIColor+WPColors.m

@implementation UIColor (WPColors)

+ (UIColor *)wp_darkBlue {
    return [UIColor colorWithRed:85.0/255.0 green:141.0/255.0 blue:173.0/255.0 alpha:1];
}

+ (UIColor *)wp_blue {
    return [UIColor colorWithRed:129.0/255.0 green:180.0/255.0 blue:222.0/255.0 alpha:1];
}

+ (UIColor *)wp_lightBlue {
    return [UIColor colorWithRed:188.0/255.0 green:218.0/255.0 blue:245.0/255.0 alpha:1];
}

+ (UIColor *)wp_facebookBlue {
    return [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1.0];
}

+ (UIColor *)wp_transWhite {
    return [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5];
}

@end
