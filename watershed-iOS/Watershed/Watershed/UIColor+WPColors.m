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

+ (UIColor *)wp_blue {
    return [UIColor colorWithRed:129.0/255.0 green:180.0/255.0 blue:222.0/255.0 alpha:1];
}

+ (UIColor *)wp_darkBlue {
    return [UIColor colorWithRed:85.0/255.0 green:141.0/255.0 blue:173.0/255.0 alpha:1];
}

+ (UIColor *)wp_lightBlue {
    return [UIColor colorWithRed:188.0/255.0 green:218.0/255.0 blue:245.0/255.0 alpha:1];
}
@end
