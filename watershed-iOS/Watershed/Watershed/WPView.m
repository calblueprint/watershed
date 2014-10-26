//
//  WPView.m
//  Watershed
//
//  Created by Andrew on 10/25/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPView.h"

@interface WPView ()

@property UIView *navbarView;
@property BOOL navbarVisible;

@end

@implementation WPView

- (instancetype)initWithFrame:(CGRect)frame
                visibleNavbar:(BOOL)visible {
    self = [super initWithFrame:frame];
    if (self) {
        
        _navbarVisible = visible;
        if (visible) {
            _navbarView = [({
                UIView *navbarView = [[UIView alloc] init];
                navbarView.backgroundColor = [UIColor wp_blue];
                navbarView;
            }) wp_addToSuperview:self];
        }
        
        [self setNeedsUpdateConstraints];
    }
    return self;

}

- (void)updateConstraints {
    if (self.navbarVisible) {
        [self.navbarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@64);
            make.top.equalTo(@0);
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
        }];
    }
    
    [super updateConstraints];
}

@end
