//
//  WPSignupViewController.m
//  Watershed
//
//  Created by Melissa Huang on 12/2/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSignupViewController.h"

@implementation WPSignupViewController

- (void)viewDidLoad {
    self.navigationItem.title = @"Create Account";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)loadView {
    self.view = [[WPSignupView alloc] init];
}

@end

@implementation WPSignupView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"about_watershed.png"]];
        [self createSubviews];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)createSubviews {
    _nameField = [[UITextField alloc] init];
    _nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" Full Name"
                                                                        attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _nameField.font = [UIFont fontWithName:@"Helvetica" size:12];
    _nameField.textColor = [UIColor whiteColor];
    _nameField.backgroundColor = [UIColor wp_transBlack];
    [self addSubview:_nameField];
    
    _emailField = [[UITextField alloc] init];
    _emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" Email address"
                                                                       attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _emailField.font = [UIFont fontWithName:@"Helvetica" size:12];
    _emailField.textColor = [UIColor whiteColor];
    _emailField.backgroundColor = [UIColor wp_transBlack];
    [self addSubview:_emailField];
    
}

- (void)updateConstraints {
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin+2*standardMargin));
        make.leading.equalTo(@30);
        make.trailing.equalTo(@-30);
        make.height.equalTo(@40);
    }];
    
    [self.emailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameField.mas_bottom).with.offset(standardMargin);
        make.leading.equalTo(self.nameField.mas_leading);
        make.trailing.equalTo(self.nameField.mas_trailing);
        make.height.equalTo(self.nameField.mas_height);
    }];
    
    [super updateConstraints];
}

@end