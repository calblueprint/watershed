//
//  WPFieldReportView.m
//  Watershed
//
//  Created by Andrew Millman on 11/9/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPFieldReportView.h"

@implementation WPFieldReportView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame visibleNavbar:NO];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubviews];
        [self setUpActions];
        [self updateConstraints];
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)createSubviews {
    
}

- (void)setUpActions {
    
}

@end
