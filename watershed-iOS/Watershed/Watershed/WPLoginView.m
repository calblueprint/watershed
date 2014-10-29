//
//  WPLoginView.m
//  Watershed
//
//  Created by Andrew Millman on 9/28/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPLoginView.h"

@interface WPLoginView ()

@property (nonatomic) UIView *logoView;
@property (nonatomic) UIView *appIconView;
@property (nonatomic) UIView *appTitleLabel;

@property (nonatomic) UIView *emailButton;
@property (nonatomic) UIView *facebookButton;

@end

@implementation WPLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame visibleNavbar:NO];
    if (self) {
        self.backgroundColor = [UIColor wp_blue];
        [self createSubviews];
        [self setUpActions];
        [self updateConstraints];
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)createSubviews {
    UIButton *emailButton = [[UIButton alloc] init];
    emailButton.backgroundColor = [UIColor wp_transWhite];
    [emailButton setTitle:@"Sign in with Email" forState:UIControlStateNormal];
    emailButton.layer.cornerRadius = 5.0;
    
    UIImageView *emailIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"EmailIcon"]];
    [emailIconView setFrame:CGRectMake(10, 10, 30, 30)];
    emailIconView.contentMode = UIViewContentModeScaleAspectFit;
    [emailButton addSubview:emailIconView];
    
    _emailButton = emailButton;
    [self addSubview:emailButton];
    
    UIButton *facebookButton = [[UIButton alloc] init];
    facebookButton.backgroundColor = [UIColor wp_facebookBlue];
    [facebookButton setTitle:@"Sign in with Facebook" forState:UIControlStateNormal];
    facebookButton.layer.cornerRadius = 5.0;
    
    UIImageView *facebookIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FacebookIcon"]];
    [facebookIconView setFrame:CGRectMake(10, 13, 30, 24)];
    facebookIconView.contentMode = UIViewContentModeScaleAspectFit;
    [facebookButton addSubview:facebookIconView];
    
    _facebookButton = facebookButton;
    [self addSubview:facebookButton];
    
    UIView *logoView = [[UIView alloc] init];
    _logoView = logoView;
    [self addSubview:logoView];
    
    UIImageView *appIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
    appIconView.contentMode = UIViewContentModeScaleAspectFit;
    _appIconView = appIconView;
    [self.logoView addSubview:appIconView];
    
    UILabel *appTitleLabel = [[UILabel alloc] init];
    appTitleLabel.text = @"Watershed";
    appTitleLabel.textColor = [UIColor whiteColor];
    appTitleLabel.font = [UIFont systemFontOfSize:27.0];
    appTitleLabel.textAlignment = NSTextAlignmentCenter;
    _appTitleLabel = appTitleLabel;
    [self.logoView addSubview:appTitleLabel];
    
    
}

- (void)setUpActions {
    // Here is where you set up buttons taps and gesture recognizers.
}

- (void)updateConstraints {
    
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).with.offset(-50.0);
        make.width.equalTo(@200);
    }];
    
    [self.appIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@100);
        make.top.equalTo(@0);
        make.trailing.equalTo(@0);
        make.leading.equalTo(@0);
    }];
    
    [self.appTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appIconView.mas_bottom);
        make.height.equalTo(@50);
        make.bottom.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
    [self.emailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo([UIView wp_styleNegativePadding]);
        make.leading.equalTo([UIView wp_stylePadding]);
        make.trailing.equalTo([UIView wp_styleNegativePadding]);
        make.height.equalTo(@50);
    }];
    
    [self.facebookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.emailButton.mas_top).with.offset([[UIView wp_styleNegativePadding] floatValue]);
        make.leading.equalTo([UIView wp_stylePadding]);
        make.trailing.equalTo([UIView wp_styleNegativePadding]);
        make.height.equalTo(@50);
    }];
    
    [super updateConstraints];
}

@end
