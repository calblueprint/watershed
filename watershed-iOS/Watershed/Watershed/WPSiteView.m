//
//  WPSiteView.m
//  Watershed
//
//  Created by Andrew on 10/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSiteView.h"
#import "Masonry.h"
#import "UIColor+WPColors.h"
#import "UIView+WPExtensions.h"
#import "UIImage+ImageEffects.h"

@interface WPSiteView ()

@property (nonatomic) UIImageView *coverPhotoView;

@end

@implementation WPSiteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
        [self setUpActions];
        [self updateConstraints];
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)createSubviews {

    UIImage *coverPhoto = [UIImage imageNamed:@"SampleCoverPhoto"];
    UIImageView *coverPhotoView = [[UIImageView alloc] initWithImage:coverPhoto];
    [coverPhotoView setContentMode:UIViewContentModeScaleAspectFill];
    _coverPhotoView = coverPhotoView;
    
    
}

- (void)setUpActions {
    // Here is where you set up buttons taps and gesture recognizers.
}

- (void)updateConstraints {
    
    [self.coverPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@200);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
    [super updateConstraints];
}

@end

