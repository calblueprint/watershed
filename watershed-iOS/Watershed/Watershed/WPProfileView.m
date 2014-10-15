//
//  WPProfileView.m
//  Watershed
//
//  Created by Melissa Huang on 10/14/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPProfileView.h"
#import "Masonry.h"
#import "UIColor+WPColors.h"
#import "UIView+WPExtensions.h"

#import <QuartzCore/QuartzCore.h>

@interface WPProfileView ()

@property (nonatomic) UIView *profilePictureView;

@end


@implementation WPProfileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor wp_blue];
        [self createSubviews];
        //[self setUpActions];
        [self updateConstraints];
    }
    return self;
}

#pragma mark - View Hierarchy

-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (void)createSubviews {

    UIImageView *profilePictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,20,20)];
    profilePictureView.contentMode = UIViewContentModeScaleAspectFit;

//    profilePictureView.frame = CGRectMake(0,0, 30, 30);
//    profilePictureView.bounds = CGRectMake(0,0, 30, 30);
    profilePictureView.clipsToBounds = YES;
    
    [self setRoundedView:profilePictureView toDiameter:10];
    [profilePictureView setImage:[UIImage imageNamed:@"profilePicture.png"]];

    _profilePictureView = profilePictureView;
    [self addSubview:profilePictureView];


    
    
}

- (void)updateConstraints {

    [self.profilePictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@100);
        make.left.equalTo(@50);
//        make.bottom.equalTo([UIView wp_styleNegativePadding]);
//        make.leading.equalTo([UIView wp_stylePadding]);
//        make.trailing.equalTo([UIView wp_styleNegativePadding]);
//        make.height.equalTo(@50);
    }];
    
    
    [super updateConstraints];
}


@end
