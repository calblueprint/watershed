//
//  WPLoginView.m
//  Watershed
//
//  Created by Melissa Huang on 11/12/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPLoginView.h"
#import "UIExtensions.h"
#import "WPLoginViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface WPLoginView ()

@property (nonatomic) FBLoginView *fbLoginView;
@property (nonatomic) UIButton *emailButton;
@property (nonatomic) UIButton *signupButton;
@property (nonatomic) UILabel *noAccountLabel;
@property (nonatomic) UIImageView *emailIconView;
@property (nonatomic) UIImageView *signInEmailIconView;
@property (nonatomic) UIImageView *signInPasswordIconView;
@property (nonatomic) UIImageView *appIconView;
@property (nonatomic) UILabel *appTitleLabel;
@property (nonatomic) MASConstraint *emailButtonTopConstraint;
@property (nonatomic) UIView *emailLine;
@property (nonatomic) UIView *passwordLine;

@property (nonatomic) BOOL isFirstTime;
@property (nonatomic) BOOL emailClicked;

@end


@implementation WPLoginView


- (instancetype)initWithParentController:(WPLoginViewController *)parentVC {
    self = [super initWithFrame:[WPView getScreenFrame]];
    if (self) {
        self.parentViewController = parentVC;
        _isFirstTime = YES;
        _emailClicked = NO;
        [self createSubviews];
        [self setupActions];
        [self setNeedsUpdateConstraints];
        self.backgroundColor = [UIColor wp_blue];
    }
    return self;
}

-(void)dismissKeyboard {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (void)setupActions {
    [_emailButton addTarget:self action:@selector(showEmailInput) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showEmailInput {
    
    _emailLine = [[UIView alloc] init];
    _emailLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:_emailLine];

    _passwordLine = [[UIView alloc] init];
    _passwordLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:_passwordLine];
 
    self.emailButtonTopConstraint.offset = 90;
    [self.emailButton setNeedsUpdateConstraints];

    [UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.emailButton.backgroundColor = [UIColor wp_lightGreen];
        [self.emailButton layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (!_emailClicked) {
            FAKIonIcons *emailIcon = [FAKIonIcons androidMailIconWithSize:20];
            [emailIcon addAttribute:NSForegroundColorAttributeName
                              value:[UIColor whiteColor]];
            _signInEmailIconView = [[UIImageView alloc] initWithImage:[emailIcon imageWithSize:CGSizeMake(20, 20)]];
            [self addSubview:_signInEmailIconView];
            
            FAKIonIcons *lockIcon = [FAKIonIcons androidLockIconWithSize:20];
            [lockIcon addAttribute:NSForegroundColorAttributeName
                             value:[UIColor whiteColor]];
            _signInPasswordIconView = [[UIImageView alloc] initWithImage:[lockIcon imageWithSize:CGSizeMake(20, 20)]];
            [self addSubview:_signInPasswordIconView];
            
            _emailTextField = [[UITextField alloc] init];
            _emailTextField.font = [UIFont fontWithName:@"Helvetica" size:14];
            _emailTextField.textColor = [UIColor whiteColor];
            _emailTextField.placeholder = @"Email Address";
            _emailTextField.delegate = self;
            [_emailTextField setReturnKeyType:UIReturnKeyNext];
            [_emailTextField addTarget:self
                          action:@selector(emailToPassword)
                forControlEvents:UIControlEventEditingDidEndOnExit];
            [self addSubview:_emailTextField];
            
            _passwordTextField = [[UITextField alloc] init];
            _passwordTextField.font = [UIFont fontWithName:@"Helvetica" size:14];
            _passwordTextField.textColor = [UIColor whiteColor];
            _passwordTextField.placeholder = @"Password";
            _passwordTextField.secureTextEntry = YES;
            _passwordTextField.delegate = self;
            [_passwordTextField setReturnKeyType:UIReturnKeyGo];
            [_passwordTextField addTarget:self
                                action:@selector(didTapDoneFromPassword)
                      forControlEvents:UIControlEventEditingDidEndOnExit];
            [self addSubview:_passwordTextField];
        }
        _emailClicked = YES;
        
        [_emailButton addTarget:_parentViewController action:@selector(didTapEmailSignInButton) forControlEvents:UIControlEventTouchUpInside];
        [self setNeedsUpdateConstraints];
    }];

}

- (void)emailToPassword {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField becomeFirstResponder];
}

- (void)didTapDoneFromPassword {
    [self.passwordTextField becomeFirstResponder];
    [_parentViewController didTapEmailSignInButton];
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
    
    _fbLoginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"email"]];
    _fbLoginView.delegate = self.parentViewController;
    [self addSubview:_fbLoginView];
    
    _emailButton = [[UIButton alloc] init];
    _emailButton.backgroundColor = [UIColor wp_transWhite];
    [_emailButton setTitle:@"Sign in with Email" forState:UIControlStateNormal];
    _emailButton.layer.cornerRadius = 5.0;
    
    FAKIonIcons *mailIcon = [FAKIonIcons androidMailIconWithSize:30];
    [mailIcon addAttribute:NSForegroundColorAttributeName
                     value:[UIColor whiteColor]];
    _emailIconView = [[UIImageView alloc] initWithImage:[mailIcon imageWithSize:CGSizeMake(30, 30)]];
    [_emailButton addSubview:_emailIconView];
    [self addSubview:_emailButton];
    
    NSMutableAttributedString *underline = [[NSMutableAttributedString alloc] initWithString:@"Sign up"];
    [underline setAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[underline length])];
    _signupButton = [[UIButton alloc] init];
    [_signupButton setAttributedTitle:underline forState:UIControlStateNormal];
    _signupButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    [_signupButton addTarget:self.parentViewController action:@selector(presentSignupViewController) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_signupButton];
    
    _noAccountLabel = [[UILabel alloc] init];
    _noAccountLabel.text = @"Don't have an account?";
    _noAccountLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    _noAccountLabel.textColor = [UIColor wp_transWhite];
    [self addSubview:_noAccountLabel];

}

- (void)updateConstraints {
    if (_isFirstTime) {
        [self.appIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_centerY).with.offset(-200);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [self.appTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.appIconView.mas_bottom).with.offset(standardMargin);
        }];
        
        [self.fbLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.emailButton.mas_bottom).with.offset(standardMargin);
            make.leading.equalTo(@(wideMargin));
            make.trailing.equalTo(@(-wideMargin));
            make.height.equalTo(@45);
        }];
        
        [self.emailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            self.emailButtonTopConstraint = make.top.equalTo(self.appTitleLabel.mas_bottom).with.offset(20);
            make.leading.equalTo(self.fbLoginView.mas_leading);
            make.height.equalTo(self.fbLoginView.mas_height);
        }];
        
        [self.signupButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.fbLoginView.mas_bottom).with.offset(5);
            make.trailing.equalTo(self.fbLoginView.mas_trailing);
            make.height.equalTo(@15);
        }];
        
        [self.noAccountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.fbLoginView.mas_bottom).with.offset(5);
            make.trailing.equalTo(self.signupButton.mas_leading).with.offset(-2);
            make.height.equalTo(@15);
        }];
        
        [self.emailIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.emailButton.mas_centerY);
            make.leading.equalTo(@7);
        }];
        
        _isFirstTime = NO;
        
    } else if (_emailClicked) {
        [self.signInEmailIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.appTitleLabel.mas_bottom).with.offset(wideMargin);
            make.leading.equalTo(self.fbLoginView.mas_leading);
        }];
        
        [self.signInPasswordIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.emailLine.mas_bottom).with.offset(wideMargin);
            make.leading.equalTo(self.fbLoginView.mas_leading);
        }];
        
        [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.appTitleLabel.mas_bottom).with.offset(wideMargin);
            make.leading.equalTo(self.signInEmailIconView.mas_right).with.offset(5);
            make.height.equalTo(@15);
            make.width.equalTo(self.fbLoginView.mas_width);
        }];
        
        [self.emailLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.trailing.equalTo(self.fbLoginView.mas_trailing);
            make.bottom.equalTo(self.emailTextField.mas_bottom).with.offset(5);
            make.left.equalTo(self.emailTextField.mas_left);
        }];
        
        [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.emailLine.mas_bottom).with.offset(wideMargin);
            make.leading.equalTo(self.signInPasswordIconView.mas_right).with.offset(5);
            make.height.equalTo(@(wideMargin));
            make.width.equalTo(self.fbLoginView.mas_width);
        }];
        
        [self.passwordLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.trailing.equalTo(self.fbLoginView.mas_trailing);
            make.bottom.equalTo(self.passwordTextField.mas_bottom).with.offset(5);
            make.left.equalTo(self.passwordTextField.mas_left);
        }];
        
    }

    [super updateConstraints];
}
@end


