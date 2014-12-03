//
//  WPSignupViewController.m
//  Watershed
//
//  Created by Melissa Huang on 12/2/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSignupViewController.h"

@interface WPSignupViewController()

@property (nonatomic) WPSignupView *view;

@end

@implementation WPSignupViewController

- (void)viewDidLoad {
    self.navigationItem.title = @"Create Account";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)loadView {
    self.view = [[WPSignupView alloc] init];
}

- (void)emailSignup {
    if ([self.view.passwordField.text isEqualToString:self.view.confirmPasswordField.text]) {
        
    } else {
        UIAlertView *passwordNotMatchAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"Passwords must match"
                                                                       delegate:self
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
        [passwordNotMatchAlert show];
    }
}

@end

@implementation WPSignupView

- (instancetype)initWithParent:(WPSignupViewController *)parent {
    self = [super init];
    if (self) {
        self.parentViewController = parent;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"about_watershed.png"]];
        [self createSubviews];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)createSubviews {
    
    UIView *nameSpacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _nameField = [[UITextField alloc] init];
    _nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Full Name"
                                                                        attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    _nameField.font = [UIFont fontWithName:@"Helvetica" size:12];
    _nameField.textColor = [UIColor blackColor];
    _nameField.backgroundColor = [UIColor whiteColor];
    [_nameField setLeftViewMode:UITextFieldViewModeAlways];
    [_nameField setLeftView:nameSpacerView];
    [self addSubview:_nameField];
    
    UIView *emailSpacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _emailField = [[UITextField alloc] init];
    _emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Address"
                                                                       attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    _emailField.font = [UIFont fontWithName:@"Helvetica" size:12];
    _emailField.textColor = [UIColor blackColor];
    _emailField.backgroundColor = [UIColor whiteColor];
    [_emailField setLeftViewMode:UITextFieldViewModeAlways];
    [_emailField setLeftView:emailSpacerView];
    [self addSubview:_emailField];
    
    UIView *passwordSpacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _passwordField = [[UITextField alloc] init];
    _passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password"
                                                                        attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    _passwordField.font = [UIFont fontWithName:@"Helvetica" size:12];
    _passwordField.textColor = [UIColor blackColor];
    _passwordField.backgroundColor = [UIColor whiteColor];
    [_passwordField setLeftViewMode:UITextFieldViewModeAlways];
    [_passwordField setLeftView:passwordSpacerView];
    _passwordField.secureTextEntry = YES;
    [self addSubview:_passwordField];
    
    UIView *confirmSpacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _confirmPasswordField = [[UITextField alloc] init];
    _confirmPasswordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password"
                                                                           attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    _confirmPasswordField.font = [UIFont fontWithName:@"Helvetica" size:12];
    _confirmPasswordField.textColor = [UIColor blackColor];
    _confirmPasswordField.backgroundColor = [UIColor whiteColor];
    [_confirmPasswordField setLeftViewMode:UITextFieldViewModeAlways];
    [_confirmPasswordField setLeftView:confirmSpacerView];
    _confirmPasswordField.secureTextEntry = YES;
    [self addSubview:_confirmPasswordField];
    
    _signupButton = [[UIButton alloc] init];
    _signupButton.backgroundColor = [UIColor wp_lightGreen];
    [_signupButton setTitle:@"Sign up" forState:UIControlStateNormal];
    [_signupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_signupButton addTarget:self.parentViewController action:@selector(emailSignup) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_signupButton];
}

- (void)updateConstraints {
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin+2*standardMargin));
        make.leading.equalTo(@30);
        make.trailing.equalTo(@-30);
        make.height.equalTo(@40);
    }];
    
    [self.emailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameField.mas_bottom).with.offset(1);
        make.leading.equalTo(self.nameField.mas_leading);
        make.trailing.equalTo(self.nameField.mas_trailing);
        make.height.equalTo(self.nameField.mas_height);
    }];
    
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emailField.mas_bottom).with.offset(1);
        make.leading.equalTo(self.nameField.mas_leading);
        make.trailing.equalTo(self.nameField.mas_trailing);
        make.height.equalTo(self.nameField.mas_height);
    }];
    
    [self.confirmPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.mas_bottom).with.offset(1);
        make.leading.equalTo(self.nameField.mas_leading);
        make.trailing.equalTo(self.nameField.mas_trailing);
        make.height.equalTo(self.nameField.mas_height);
    }];
    
    [self.signupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmPasswordField.mas_bottom).with.offset(standardMargin);
        make.leading.equalTo(self.nameField.mas_leading);
        make.trailing.equalTo(self.nameField.mas_trailing);
        make.height.equalTo(self.nameField.mas_height);
    }];
    
    [super updateConstraints];
}

@end