//
//  WPFieldReportView.m
//  Watershed
//
//  Created by Andrew Millman on 11/9/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPFieldReportView.h"

@interface WPFieldReportView () <UIScrollViewDelegate>
@property (nonatomic) UIScrollView *contentScrollView;
@property (nonatomic) UIView *navbarOverlay;
@end

const static float REPORT_IMAGE_SIZE = 220.0f;
const static float RATING_SIZE = 90.0f;
const static float USER_IMAGE_SIZE = 50.0f;
const static float BORDER_WIDTH = 6.0f;

@implementation WPFieldReportView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)createSubviews {
    
    _navbarOverlay = [({
        UIView *overlay = [[UIView alloc] init];
        overlay.backgroundColor = [UIColor blackColor];
        overlay.alpha = 0;
        overlay;
    }) wp_addToSuperview:self];
    
    _contentScrollView = [({
        UIScrollView *contentScrollView = [[UIScrollView alloc] init];
        contentScrollView.delegate = self;
        contentScrollView;
    }) wp_addToSuperview:self];
    
    _reportImageView = [({
        UIImageView *reportImageView = [[UIImageView alloc] init];
        [reportImageView setContentMode:UIViewContentModeScaleAspectFill];
        reportImageView.layer.cornerRadius = REPORT_IMAGE_SIZE / 2;
        reportImageView.clipsToBounds = YES;
        reportImageView.alpha = 0;
        reportImageView;
    }) wp_addToSuperview:self.contentScrollView];
    
    _ratingNumberLabel = [({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:45.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        label.layer.cornerRadius = RATING_SIZE / 2;
        label.layer.borderWidth = BORDER_WIDTH;
        label.clipsToBounds = YES;
        
        CALayer *mask = [CALayer layer];
        mask.frame = CGRectMake(1, 1, RATING_SIZE - 2, RATING_SIZE - 2);
        mask.backgroundColor = [[UIColor whiteColor] CGColor];
        mask.cornerRadius = (RATING_SIZE - 1)/2;
        mask.opacity = 1.0;
        
        label.layer.mask = mask;
        label.alpha = 0;
        label;
    }) wp_addToSuperview:self.contentScrollView];
    
    _userImageView = [({
        UIImageView *userImageView = [[UIImageView alloc] init];
        [userImageView setContentMode:UIViewContentModeScaleAspectFill];
        userImageView.layer.cornerRadius = USER_IMAGE_SIZE / 2;
        userImageView.layer.borderWidth = BORDER_WIDTH - 1;
        userImageView.clipsToBounds = YES;
        
        CALayer *mask = [CALayer layer];
        mask.frame = CGRectMake(1, 1, USER_IMAGE_SIZE - 2, USER_IMAGE_SIZE - 2);
        mask.backgroundColor = [[UIColor whiteColor] CGColor];
        mask.cornerRadius = (USER_IMAGE_SIZE - 1)/2;
        mask.opacity = 1.0;
        
        userImageView.layer.mask = mask;
        userImageView.alpha = 0;
        userImageView;
    }) wp_addToSuperview:self.contentScrollView];
    
    _titleLabel = [({
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:28.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.alpha = 0.4;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 0;
        titleLabel;
    }) wp_addToSuperview:self.contentScrollView];
    
    _userLabel = [({
        UILabel *userLabel = [[UILabel alloc] init];
        userLabel.font = [UIFont systemFontOfSize:16.0];
        userLabel.textAlignment = NSTextAlignmentCenter;
        userLabel.textColor = [UIColor blackColor];
        userLabel.alpha = 0.4;
        userLabel.lineBreakMode = NSLineBreakByWordWrapping;
        userLabel.numberOfLines = 0;
        userLabel;
    }) wp_addToSuperview:self.contentScrollView];
    
    _descriptionLabel = [({
        UILabel *descriptionLabel = [[UILabel alloc] init];
        descriptionLabel.font = [UIFont systemFontOfSize:16.0];
        descriptionLabel.textColor = [UIColor whiteColor];
        descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        descriptionLabel.numberOfLines = 0;
        descriptionLabel;
    }) wp_addToSuperview:self.contentScrollView];
}

- (void)updateConstraints {
    
    [self.navbarOverlay mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.height.equalTo(@(topMargin));
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
    [self.contentScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.bottom.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
    [self.reportImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(standardMargin * 2));
        make.height.equalTo(@(REPORT_IMAGE_SIZE));
        make.width.equalTo(@(REPORT_IMAGE_SIZE));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.ratingNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(RATING_SIZE));
        make.width.equalTo(@(RATING_SIZE));
        make.centerX.equalTo(self.reportImageView.mas_centerX)
            .with.offset(-REPORT_IMAGE_SIZE / 2 / 1.41);
        make.centerY.equalTo(self.reportImageView.mas_centerY)
            .with.offset(-REPORT_IMAGE_SIZE / 2 / 1.41);
    }];
    
    [self.userImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(USER_IMAGE_SIZE));
        make.width.equalTo(@(USER_IMAGE_SIZE));
        make.centerX.equalTo(self.reportImageView.mas_centerX)
            .with.offset(REPORT_IMAGE_SIZE / 2 / 1.41);
        make.centerY.equalTo(self.reportImageView.mas_centerY)
            .with.offset(REPORT_IMAGE_SIZE / 2 / 1.41);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.reportImageView.mas_bottom)
            .with.offset(standardMargin * 2);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userLabel.mas_bottom)
            .with.offset(standardMargin * 2);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
        make.bottom.equalTo(@(-standardMargin));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [super updateConstraints];
}

#pragma mark - ScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat trans = scrollView.contentOffset.y;
    CGFloat navbarAlpha = trans / 400;
    if (navbarAlpha > 0.1) navbarAlpha = 0.1;
    self.navbarOverlay.alpha = navbarAlpha;
}


#pragma mark - UIView Modifications

- (void)showBubbles {
    [UIView animateWithDuration:0.5 animations:^{
        self.reportImageView.alpha = 1;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.ratingNumberLabel.alpha = 1;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.userImageView.alpha = 1;
            }];
        }];
    }];
}

@end
