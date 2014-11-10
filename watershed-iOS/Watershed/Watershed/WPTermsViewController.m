//
//  WPTermsViewController.m
//  Watershed
//
//  Created by Melissa Huang on 11/9/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTermsViewController.h"
#import "UIExtensions.h"

@implementation WPTermsViewController

- (void)viewDidLoad {
    self.navigationItem.title = @"Terms and Privacy";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)loadView {
    self.view = [[WPTermsView alloc] init];
}

@end

@implementation WPTermsView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubviews];
        [self setNeedsUpdateConstraints];
        self.backgroundColor = [UIColor wp_blue];
    }
    return self;
}

- (void)createSubviews {
    
    _termsLabel = [[UILabel alloc] init];
    _termsLabel.text = @"Terms";
    [self addSubview:_termsLabel];
    
}

- (void)updateConstraints {
    
    [self.termsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin + standardMargin));
        make.leading.equalTo(@(standardMargin));
    }];
    
    [super updateConstraints];
}

@end
