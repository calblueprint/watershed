//
//  WPLoginView.m
//  Watershed
//
//  Created by Andrew on 9/28/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPLoginView.h"
#import "Masonry.h"

@interface WPLoginView ()

@property (nonatomic) UIView *logoView;
@property (nonatomic) UIView *emailButton;

@end

@implementation WPLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:129.0/255.0
                                                    green:180.0/255.0
                                                     blue:222.0/255.0
                                                    alpha:1.0];
        [self createSubviews];
        [self setUpActions];
        [self updateConstraints];
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)createSubviews {
    UIButton *emailButton = [[UIButton alloc] init];
    emailButton.backgroundColor = [UIColor colorWithRed:1.0
                                                  green:1.0
                                                   blue:1.0
                                                  alpha:0.5];
    [emailButton setTitle:@"Sign in with Email" forState:UIControlStateNormal];
    emailButton.layer.cornerRadius = 5.0;
    
    UIImageView *emailIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"EmailIcon"]];
    [emailIconView setFrame:CGRectMake(10, 10, 30, 30)];
    emailIconView.contentMode = UIViewContentModeScaleAspectFit;
    
    [emailButton addSubview:emailIconView];
    
    self.emailButton = emailButton;
    [self addSubview:emailButton];
}

- (void)setUpActions {
    // Here is where you set up buttons taps and gesture recognizers.
}

- (void)updateConstraints {
    [self.emailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-10);
        make.leading.equalTo(@10);
        make.trailing.equalTo(@(-10));
        make.height.equalTo(@50);
    }];
    
    [super updateConstraints];
}

@end
