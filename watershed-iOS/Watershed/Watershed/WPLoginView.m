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
@property (nonatomic) UIButton *signupButton;

@end


@implementation WPLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    frame =  UIScreen.mainScreen.bounds;
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
        [self setupActions];
        [self setNeedsUpdateConstraints];
        self.backgroundColor = [UIColor wp_blue];
    }
    return self;
}
         
- (void)setupActions {
    [_emailButton addTarget:self action:@selector(showEmailInput) forControlEvents:UIControlEventTouchUpInside];
}

//http://stackoverflow.com/questions/6972092/ios-how-to-store-username-password-within-an-app
- (void)showEmailInput {
    //animate email
    
    _emailTextField = [[UITextField alloc] init];
    _emailTextField.font = [UIFont fontWithName:@"Helvetica" size:10];
    _emailTextField.textColor = [UIColor whiteColor];
    _emailTextField.placeholder = @"Email";
    [self addSubview:_emailTextField];
    
    _passwordTextField = [[UITextField alloc] init];
    _passwordTextField.font = [UIFont fontWithName:@"Helvetica" size:10];
    _passwordTextField.textColor = [UIColor whiteColor];
    _passwordTextField.placeholder = @"Password";
    _passwordTextField.secureTextEntry = YES;
    [self addSubview:_passwordTextField];
    
    _signupButton = [[UIButton alloc] init];
    [_signupButton setTitle:@"Sign up" forState:UIControlStateNormal];
    
    SEL emailSignupSelector = sel_registerName("emailSignup");
    [_signupButton addTarget:_parentViewController action:emailSignupSelector forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_signupButton];
    
    [self updateConstraints];
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
    _emailIconView.tintColor = [UIColor whiteColor];
    [_emailButton addSubview:_emailIconView];
    [self addSubview:_emailButton];

}

- (void)updateConstraints {

    [self.appIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).with.offset(-180);
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
        make.height.equalTo(@45);
    }];
    
    [self.emailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.fbLoginView.mas_bottom).with.offset(10);
        make.leading.equalTo(self.fbLoginView.mas_leading);
        make.height.equalTo(self.fbLoginView.mas_height);
    }];
    
    [self.emailIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.emailButton.mas_centerY);
        make.leading.equalTo(@7);
    }];
    
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emailButton.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@15);
        make.width.equalTo(self.fbLoginView.mas_width);
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emailTextField.mas_bottom);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@15);
        make.width.equalTo(self.fbLoginView.mas_width);
    }];
    
    [self.signupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom);
        make.width.equalTo(self.fbLoginView.mas_width);
        make.height.equalTo(@50);
    }];

    [super updateConstraints];
}
@end


