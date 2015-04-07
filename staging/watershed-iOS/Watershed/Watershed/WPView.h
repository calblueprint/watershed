//
//  WPView.h
//  Watershed
//
//  Created by Andrew Millman on 10/25/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIExtensions.h"

@interface WPView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                visibleNavbar:(BOOL)visible;

+ (CGFloat)getScreenWidth;
+ (CGFloat)getScreenHeight;
+ (CGRect)getScreenFrame;

@end
