//
//  UIColor+WPColors.m
//  Watershed
//
//  Created by Jordeen Chang on 9/28/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "UIColor+WPColors.h"

@implementation UIColor (WPColors)

+ (UIColor *)wp_blue {
    return [UIColor colorWithRed:129.0/255.0 green:180.0/255.0 blue:222.0/255.0 alpha:1];
}

+ (UIColor *)wp_darkBlue {
    return [UIColor colorWithRed:85.0/255.0 green:141.0/255.0 blue:173.0/255.0 alpha:1];
}

+ (UIColor *)wp_lightBlue {
    return [UIColor colorWithRed:188.0/255.0 green:218.0/255.0 blue:245.0/255.0 alpha:1];
}

+ (UIColor *)wp_facebookBlue {
    return [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1.0];
}

+ (UIColor *)wp_green {
    return [UIColor colorWithRed:11.0/255.0 green:173.0/255.0 blue:94.0/255.0 alpha:1.0];
}

+ (UIColor *)wp_transWhite {
    return [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5];
}

+ (UIColor *)wp_transparentBlue {
    return [UIColor colorWithRed:129.0/255.0 green:180.0/255.0 blue:222.0/255.0 alpha:0.3];
}

+ (UIColor *)wp_transparentDarkBlue {
    return [UIColor colorWithRed:85.0/255.0 green:141.0/255.0 blue:173.0/255.0 alpha:0.3];
}

+ (UIColor *)wp_red {
    return [UIColor colorWithRed:231/255.0 green:76/255.0 blue:60/255.0 alpha:1];
}

+ (UIColor *)wp_orange {
    return [UIColor colorWithRed:230/255.0 green:126/255.0 blue:34/255.0 alpha:1];
}

+ (UIColor *)wp_yellow {
    return [UIColor colorWithRed:241/255.0 green:196/255.0 blue:15/255.0 alpha:1];
}

+ (UIColor *)wp_lime {
    return [UIColor colorWithRed:164/255.0 green:196/255.0 blue:0/255.0 alpha:1];
}

+ (UIColor *)wp_lightGreen {
    return [UIColor colorWithRed:46/255.0 green:204/255.0 blue:113/255.0 alpha:1];
}

+ (UIColor *)wp_paragraph {
    return [UIColor grayColor];
}

+ (UIColor *)wp_header {
    return [UIColor wp_darkBlue];
}


+ (UIColor *)colorForRating:(NSInteger)rating {
    switch (rating) {
        case 1:
            return [UIColor wp_red];
            break;
            
        case 2:
            return [UIColor wp_orange];
            break;
            
        case 3:
            return [UIColor wp_yellow];
            break;
            
        case 4:
            return [UIColor wp_lime];
            break;
            
        case 5:
            return [UIColor wp_lightGreen];
            break;
        default:
            return [UIColor grayColor];
            break;
    }
}

@end
