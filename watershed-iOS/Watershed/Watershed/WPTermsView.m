//
//  WPTermsView.m
//  Watershed
//
//  Created by Andrew Millman on 1/24/15.
//  Copyright (c) 2015 Blueprint. All rights reserved.
//

#import "WPTermsView.h"

@implementation WPTermsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame visibleNavbar:YES];
    if (self) {
        [self createSubviews];
        [self setNeedsUpdateConstraints];
        self.backgroundColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1];
    }
    return self;
}

- (void)createSubviews {

    _scrollView = [({
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.alwaysBounceVertical = YES;
        scrollView;
    }) wp_addToSuperview:self];

    _termsLabel = [({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Terms";
        label.textColor = [UIColor whiteColor];
        label;
    }) wp_addToSuperview:self.scrollView];

    _termsInfoLabel = [({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"These are our terms.";
        label.font= [UIFont systemFontOfSize:12];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        label;
    }) wp_addToSuperview:self.scrollView];

    _privacyLabel = [({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Privacy";
        label.textColor = [UIColor whiteColor];
        label;
    }) wp_addToSuperview:self.scrollView];

    _privacyInfoLabel = [({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"These are our privacy policies.";
        label.font= [UIFont systemFontOfSize:12];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        label;
    }) wp_addToSuperview:self.scrollView];
}

- (void)updateConstraints {

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];

    [self.termsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(standardMargin));
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
