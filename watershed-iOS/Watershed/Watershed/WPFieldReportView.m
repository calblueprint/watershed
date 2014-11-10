//
//  WPFieldReportView.m
//  Watershed
//
//  Created by Andrew Millman on 11/9/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPFieldReportView.h"

@interface WPFieldReportView ()

@property (nonatomic) UIScrollView *contentScrollView;
@property (nonatomic) UILabel *ratingNumberLabel;
@property (nonatomic) UILabel *ratingTextLabel;
@property (nonatomic) UIImageView *reportImageView;
@property (nonatomic) UIImageView *userImageView;
@property (nonatomic) UILabel *descriptionLabel;

@end

const static float RATING_SIZE = 200.0f;
const static float REPORT_IMAGE_SIZE = 90.0f;
const static float USER_IMAGE_SIZE = 50.0f;
const static float BORDER_WIDTH = 5.0f;

@implementation WPFieldReportView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor wp_yellow];
        [self createSubviews];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)createSubviews {
    
    _contentScrollView = [({
        UIScrollView *contentScrollView = [[UIScrollView alloc] init];
        contentScrollView;
    }) wp_addToSuperview:self];
    
    _ratingNumberLabel = [({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"3";
        label.font = [UIFont systemFontOfSize:100.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor wp_yellow];
        label.backgroundColor = [UIColor whiteColor];
        label.layer.cornerRadius = RATING_SIZE / 2;
        label.clipsToBounds = YES;
        label;
    }) wp_addToSuperview:self.contentScrollView];
    
    _ratingTextLabel = [({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"RATING";
        label.font = [UIFont systemFontOfSize:15.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.alpha = 0.5;
        label;
    }) wp_addToSuperview:self.contentScrollView];
    
    _reportImageView = [({
        UIImageView *reportImageView = [[UIImageView alloc] init];
        reportImageView.image = [UIImage imageNamed:@"SampleCoverPhoto"];
        [reportImageView setContentMode:UIViewContentModeScaleAspectFill];
        reportImageView.layer.cornerRadius = REPORT_IMAGE_SIZE / 2;
        reportImageView.layer.borderWidth = BORDER_WIDTH;
        reportImageView.layer.borderColor = [[UIColor wp_yellow] CGColor];
        reportImageView.clipsToBounds = YES;
        
        CALayer *mask = [CALayer layer];
        mask.frame = CGRectMake(1, 1, REPORT_IMAGE_SIZE - 2, REPORT_IMAGE_SIZE - 2);
        mask.backgroundColor = [[UIColor whiteColor] CGColor];
        mask.cornerRadius = (REPORT_IMAGE_SIZE - 1)/2;
        mask.opacity = 1.0;
        
        reportImageView.layer.mask = mask;
        reportImageView;
    }) wp_addToSuperview:self.contentScrollView];
    
    _userImageView = [({
        UIImageView *userImageView = [[UIImageView alloc] init];
        userImageView.image = [UIImage imageNamed:@"max"];
        [userImageView setContentMode:UIViewContentModeScaleAspectFill];
        userImageView.layer.cornerRadius = USER_IMAGE_SIZE / 2;
        userImageView.layer.borderWidth = BORDER_WIDTH - 1;
        userImageView.layer.borderColor = [[UIColor wp_yellow] CGColor];
        userImageView.clipsToBounds = YES;
        
        CALayer *mask = [CALayer layer];
        mask.frame = CGRectMake(1, 1, USER_IMAGE_SIZE - 2, USER_IMAGE_SIZE - 2);
        mask.backgroundColor = [[UIColor whiteColor] CGColor];
        mask.cornerRadius = (USER_IMAGE_SIZE - 1)/2;
        mask.opacity = 1.0;
        
        userImageView.layer.mask = mask;
        userImageView;
    }) wp_addToSuperview:self.contentScrollView];
    
    _descriptionLabel = [({
        UILabel *descriptionLabel = [[UILabel alloc] init];
        descriptionLabel.text = @"Cal Blueprint is a student-run UC Berkeley organization devoted to matching the skills of its members to our desire to see social good enacted in our community. Each semester, teams of 4-5 students work closely with a non-profit to bring technological solutions to the problems they face every day.";
        descriptionLabel.font = [UIFont systemFontOfSize:16.0];
        descriptionLabel.textColor = [UIColor whiteColor];
        descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        descriptionLabel.numberOfLines = 0;
        descriptionLabel;
    }) wp_addToSuperview:self.contentScrollView];
}

- (void)updateConstraints {
    
    [self.contentScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(64));
        make.bottom.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
    [self.ratingNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(10));
        make.height.equalTo(@(RATING_SIZE));
        make.width.equalTo(@(RATING_SIZE));
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    /*[self.ratingTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(20));
        make.leading.equalTo(self.ratingNumberLabel.mas_leading);
        make.width.equalTo(self.ratingNumberLabel.mas_width);
    }];*/
    
    [self.reportImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(REPORT_IMAGE_SIZE));
        make.width.equalTo(@(REPORT_IMAGE_SIZE));
        make.centerX.equalTo(self.ratingNumberLabel.mas_centerX)
            .with.offset(-RATING_SIZE / 2 / 1.41);
        make.centerY.equalTo(self.ratingNumberLabel.mas_centerY)
            .with.offset(-RATING_SIZE / 2 / 1.41);
    }];
    
    [self.userImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(USER_IMAGE_SIZE));
        make.width.equalTo(@(USER_IMAGE_SIZE));
        make.centerX.equalTo(self.ratingNumberLabel.mas_centerX)
            .with.offset(RATING_SIZE / 2 / 1.41);
        make.centerY.equalTo(self.ratingNumberLabel.mas_centerY)
            .with.offset(RATING_SIZE / 2 / 1.41);
    }];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ratingNumberLabel.mas_bottom)
            .with.offset(40);
        make.centerX.equalTo(self.mas_centerX);
        make.leading.equalTo([UIView wp_stylePadding]);
        make.trailing.equalTo([UIView wp_styleNegativePadding]);
        make.bottom.equalTo(@-20);
    }];
    
    [super updateConstraints];
}

@end
