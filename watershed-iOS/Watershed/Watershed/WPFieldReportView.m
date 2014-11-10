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

const static float RATING_SIZE = 140.0f;
const static float REPORT_IMAGE_SIZE = 70.0f;
const static float USER_IMAGE_SIZE = 40.0f;
const static float BORDER_WIDTH = 5.0f;

@implementation WPFieldReportView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubviews];
        [self updateConstraints];
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
        reportImageView.layer.cornerRadius = REPORT_IMAGE_SIZE / 2;
        reportImageView.layer.borderWidth = BORDER_WIDTH;
        reportImageView.layer.borderColor = [[UIColor wp_yellow] CGColor];
        reportImageView;
    }) wp_addToSuperview:self.contentScrollView];
    
    _userImageView = [({
        UIImageView *userImageView = [[UIImageView alloc] init];
        userImageView.image = [UIImage imageNamed:@"max"];
        userImageView.layer.cornerRadius = USER_IMAGE_SIZE / 2;
        userImageView.layer.borderWidth = BORDER_WIDTH;
        userImageView.layer.borderColor = [[UIColor wp_yellow] CGColor];
        userImageView;
    }) wp_addToSuperview:self.contentScrollView];
    
    _descriptionLabel = [({
        UILabel *descriptionLabel = [[UILabel alloc] init];
        descriptionLabel.text = @"Cal Blueprint is a student-run UC Berkeley organization devoted to matching the skills of its members to our desire to see social good enacted in our community. Each semester, teams of 4-5 students work closely with a non-profit to bring technological solutions to the problems they face every day.";
        descriptionLabel.font = [UIFont systemFontOfSize:14.0];
        descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        descriptionLabel.numberOfLines = 0;
        descriptionLabel;
    }) wp_addToSuperview:self.contentScrollView];
}

@end
