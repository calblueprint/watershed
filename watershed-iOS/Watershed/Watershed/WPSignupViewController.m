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
    _nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Full Name"
                                                                        attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _nameField.font = [UIFont fontWithName:@"Helvetica" size:12];
    _nameField.textColor = [UIColor whiteColor];
    _nameField.backgroundColor = [UIColor wp_transBlack];
    [self addSubview:_nameField];
    
}

- (void)updateConstraints {
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin+standardMargin));
        make.leading.equalTo(@30);
        make.trailing.equalTo(@-30);
        make.height.equalTo(@40);
    }];
    
    
    [super updateConstraints];
}

@end