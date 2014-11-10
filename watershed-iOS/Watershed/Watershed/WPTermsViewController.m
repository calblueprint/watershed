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
    
    _termsInfoLabel = [[UILabel alloc] init];
    _termsInfoLabel.text = @"These are our terms.";
    _termsInfoLabel.font= [UIFont systemFontOfSize:10];
    _termsInfoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _termsInfoLabel.numberOfLines = 0;
    [self addSubview:_termsInfoLabel];
    
    _privacyLabel = [[UILabel alloc] init];
    _privacyLabel.text = @"Privacy";
    [self addSubview:_privacyLabel];
    
    _privacyInfoLabel = [[UILabel alloc] init];
    _privacyInfoLabel.text = @"This are our privacy.";
    _privacyInfoLabel.font= [UIFont systemFontOfSize:10];
    _privacyInfoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _privacyInfoLabel.numberOfLines = 0;
    [self addSubview:_privacyInfoLabel];
    
}

- (void)updateConstraints {
    
    [self.termsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin + standardMargin));
        make.leading.equalTo(@(standardMargin));
    }];
    
    [super updateConstraints];
}

@end
