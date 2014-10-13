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

@implementation WPLabledIcon

static const int VIEW_HEIGHT = 16;

- (id)initWithText:(NSString *)text
               icon:(UIImage *)icon
{
    self = [super init];
    if (self) {
        UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
        [iconView setContentMode:UIViewContentModeScaleAspectFill];
        [iconView setClipsToBounds:YES];
        [self addSubview:iconView];
        _iconView = iconView;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = text;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:label];
        _label = label;
        
        self.alpha = 0.2;
        
        [self.iconView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.height.equalTo(@(VIEW_HEIGHT));
            make.width.equalTo(@(VIEW_HEIGHT));
        }];
        
        [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(self.iconView.mas_right)
                .with.offset([[UIView wp_stylePadding] floatValue]/2);
            make.right.equalTo(@0);
        }];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.label.mas_height);
        }];
        
        [self updateConstraints];
    }
    return self;
}

@end
