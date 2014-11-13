//
//  WPLoginView.m
//  Watershed
//
//  Created by Melissa Huang on 11/12/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPLoginView.h"
#import "FontAwesomeKit/FontAwesomeKit.h"

@interface WPLoginView ()

@property (nonatomic) FBLoginView *fbLoginView;
@property (nonatomic) UIButton *emailButton;
@property (nonatomic) UIImageView *emailIconView;
@property (nonatomic) UIImageView *appIconView;
@property (nonatomic) UILabel *appTitleLabel;

@end


@implementation WPLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    frame =  UIScreen.mainScreen.bounds;
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
        [self setNeedsUpdateConstraints];
        self.backgroundColor = [UIColor wp_blue];
    }
    return self;
}

- (void)createSubviews {
    
    _appIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
    _appIconView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_appIconView];
    
    _appTitleLabel = [[UILabel alloc] init];
    _appTitleLabel.text = @"Watershed";
    _appTitleLabel.textColor = [UIColor whiteColor];
    _appTitleLabel.font = [UIFont systemFontOfSize:27.0];
    _appTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_appTitleLabel];
    
    _fbLoginView = [[FBLoginView alloc] init];
    [self addSubview:_fbLoginView];
    
    _emailButton = [[UIButton alloc] init];
    _emailButton.backgroundColor = [UIColor wp_transWhite];
    [_emailButton setTitle:@"Sign in with Email" forState:UIControlStateNormal];
    _emailButton.layer.cornerRadius = 5.0;
    
    FAKIonIcons *mailIcon = [FAKIonIcons ios7EmailOutlineIconWithSize:30];
    _emailIconView = [[UIImageView alloc] initWithImage:[mailIcon imageWithSize:CGSizeMake(30, 30)]];
    [_emailButton addSubview:_emailIconView];
    [self addSubview:_emailButton];

    

}

- (void)updateConstraints {

    [self.appIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).with.offset(-150);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.appTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.appIconView.mas_bottom).with.offset(10);
    }];
    
    [self.fbLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appTitleLabel.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@300);
    }];
    
    [self.emailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.fbLoginView.mas_bottom).with.offset(10);
        make.leading.equalTo(self.fbLoginView.mas_leading);
    }];
    
    [self.emailIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.emailButton.mas_centerY);
        make.leading.equalTo(@5);
    }];
    
    [super updateConstraints];
}
@end


