//
//  WPLabeledIcon.m
//  Watershed
//
//  Created by Andrew on 10/12/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPLabeledIcon.h"
#import "UIView+WPExtensions.h"
#import "Masonry.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation WPLabeledIcon

static const int VIEW_HEIGHT = 16;

- (id)initWithText:(NSString *)text
               icon:(UIImage *)icon {
    self = [super init];
    if (self) {
 
        _iconView = [({
            UIImageView *iconView = [[UIImageView alloc] init];
            [iconView setImage:icon];
            [iconView setContentMode:UIViewContentModeScaleAspectFill];
            [iconView setClipsToBounds:YES];
            iconView;
        }) wp_addToSuperview:self];
        
        _label = [({
            UILabel *label = [[UILabel alloc] init];
            label.text = text;
            label.font = [UIFont systemFontOfSize:14.0];
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.numberOfLines = 0;
            [label setPreferredMaxLayoutWidth:[[UIScreen mainScreen] bounds].size.width - [[UIView wp_stylePadding] floatValue]*4];
            label;
        }) wp_addToSuperview:self];
        
        // updateConstraints needs to be called
        // There is weird stuff going on with the
        // dynamic label heights
        [self updateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [self.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(VIEW_HEIGHT));
        make.width.equalTo(@(VIEW_HEIGHT));
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
    }];
    
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.greaterThanOrEqualTo(@(VIEW_HEIGHT));
        make.top.equalTo(@0);
        make.leading.equalTo(self.iconView.mas_trailing)
            .with.offset([[UIView wp_stylePadding] floatValue]/2);
    }];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.label.mas_bottom);
        make.trailing.equalTo(self.label.mas_trailing);
    }];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [self layoutSubviews];
    }
    [super updateConstraints];
}

+ (NSInteger)viewHeight { return VIEW_HEIGHT; }

@end
