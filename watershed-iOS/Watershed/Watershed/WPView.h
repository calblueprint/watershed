//
//  WPView.h
//  Watershed
//
//  Created by Andrew Millman on 10/25/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPLabeledIcon.h"
#import "UIView+WPExtensions.h"
#import "UIColor+WPColors.h"
#import "UIImage+ImageEffects.h"
#import "Masonry.h"

@interface WPView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                visibleNavbar:(BOOL)visible;

@end
