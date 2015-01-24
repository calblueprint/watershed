//
//  WPTermsView.m
//  Watershed
//
//  Created by Andrew Millman on 1/24/15.
//  Copyright (c) 2015 Blueprint. All rights reserved.
//

#import "WPTermsView.h"

@implementation WPTermsView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubviews];
        [self setNeedsUpdateConstraints];
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)createSubviews {

    _termsLabel = [[UILabel alloc] init];
    _termsLabel.text = @"Terms";
    _termsLabel.textColor = [UIColor whiteColor];
    [self addSubview:_termsLabel];

    _termsInfoLabel = [[UILabel alloc] init];
    _termsInfoLabel.text = @"These are our terms.";
    _termsInfoLabel.font= [UIFont systemFontOfSize:10];
    _termsInfoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _termsInfoLabel.numberOfLines = 0;
    _termsInfoLabel.textColor = [UIColor whiteColor];
    [self addSubview:_termsInfoLabel];

    _privacyLabel = [[UILabel alloc] init];
    _privacyLabel.text = @"Privacy";
    _privacyLabel.textColor = [UIColor whiteColor];
    [self addSubview:_privacyLabel];

    _privacyInfoLabel = [[UILabel alloc] init];
    _privacyInfoLabel.text = @"This are our privacy.";
    _privacyInfoLabel.font= [UIFont systemFontOfSize:10];
    _privacyInfoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _privacyInfoLabel.numberOfLines = 0;
    _privacyInfoLabel.textColor = [UIColor whiteColor];
    [self addSubview:_privacyInfoLabel];

}

- (void)updateConstraints {

    [self.termsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin + standardMargin));
        make.leading.equalTo(@(standardMargin));
    }];

    [self.termsInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.termsLabel.mas_bottom).with.offset(standardMargin);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(standardMargin));
    }];

    [self.privacyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.termsInfoLabel.mas_bottom).with.offset(2*standardMargin);
        make.leading.equalTo(@(standardMargin));
    }];

    [self.privacyInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.privacyLabel.mas_bottom).with.offset(standardMargin);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(standardMargin));
    }];

    [super updateConstraints];
}

@end
