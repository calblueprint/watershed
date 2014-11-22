//
//  WPLoginView.m
//  Watershed
//
//  Created by Melissa Huang on 11/12/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPLoginView.h"
#import "FontAwesomeKit/FontAwesomeKit.h"
#import "WPLoginViewController.h"

@interface WPLoginView ()

@property (nonatomic) FBLoginView *fbLoginView;
@property (nonatomic) UIButton *emailButton;
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


- (instancetype)initWithFrame:(CGRect)frame {
    
    frame = [WPView getScreenFrame];
    self = [super initWithFrame:frame];
    if (self) {
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
            FAKIonIcons *emailIcon = [FAKIonIcons ios7EmailOutlineIconWithSize:20];
            [emailIcon addAttribute:NSForegroundColorAttributeName
                              value:[UIColor whiteColor]];
            _signInEmailIconView = [[UIImageView alloc] initWithImage:[emailIcon imageWithSize:CGSizeMake(20, 20)]];
            [self addSubview:_signInEmailIconView];
            
            FAKIonIcons *lockIcon = [FAKIonIcons ios7LockedIconWithSize:20];
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
                                action:@selector(passwordToDone)
                      forControlEvents:UIControlEventEditingDidEndOnExit];
            [self addSubview:_passwordTextField];
        }
        _emailClicked = YES;
        
        SEL emailSignupSelector = sel_registerName("emailSignup");
        [_emailButton addTarget:_parentViewController action:emailSignupSelector forControlEvents:UIControlEventTouchUpInside];
        [self setNeedsUpdateConstraints];
    }];

}

- (void)emailToPassword {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField becomeFirstResponder];
}

- (void)passwordToDone {
    [self.passwordTextField becomeFirstResponder];
    [_parentViewController emailSignup];
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
    [mailIcon addAttribute:NSForegroundColorAttributeName
                     value:[UIColor whiteColor]];
    _emailIconView = [[UIImageView alloc] initWithImage:[mailIcon imageWithSize:CGSizeMake(30, 30)]];
    [_emailButton addSubview:_emailIconView];
    [self addSubview:_emailButton];

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
//            make.centerX.equalTo(self.mas_centerX);
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


