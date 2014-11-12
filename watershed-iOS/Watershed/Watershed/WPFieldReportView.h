//
//  WPFieldReportView.h
//  Watershed
//
//  Created by Andrew Millman on 11/9/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPView.h"

@interface WPFieldReportView : WPView

+ (UIColor *)colorForRating:(NSInteger)rating;
- (void)showBubbles;

@end
