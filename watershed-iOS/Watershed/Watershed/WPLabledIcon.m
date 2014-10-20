//
//  WPLabledIcon.m
//  Watershed
//
//  Created by Andrew on 10/12/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPLabledIcon.h"
#import "UIView+WPExtensions.h"
#import "Masonry.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation WPLabledIcon

static const int VIEW_HEIGHT = 16;

- (id)initWithText:(NSString *)text
               icon:(UIImage *)icon
{
    self = [super init];
    if (self) {
        UIImageView *iconView = [[UIImageView alloc] init];
        [iconView setImage:icon];
        [iconView setContentMode:UIViewContentModeScaleAspectFill];
        [iconView setClipsToBounds:YES];
        [self addSubview:iconView];
        _iconView = iconView;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = text;
        label.font = [UIFont systemFontOfSize:14.0];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        [self addSubview:label];
        [label setPreferredMaxLayoutWidth:[[UIScreen mainScreen] bounds].size.width - [[UIView wp_stylePadding] floatValue]*4];
        _label = label;
        
        self.alpha = 0.3;
        
        [self updateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
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
        make.trailing.equalTo(@0);
    }];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.label.mas_height);
    }];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [self layoutSubviews];
    }
    [super updateConstraints];
}

+ (NSInteger)viewHeight { return VIEW_HEIGHT; }

@end
