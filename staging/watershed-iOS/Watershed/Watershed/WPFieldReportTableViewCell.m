//
//  WPFieldReportTableViewCell.m
//  Watershed
//
//  Created by Andrew Millman on 11/3/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPFieldReportTableViewCell.h"

@interface WPFieldReportTableViewCell ()
@property (nonatomic) UILabel *ratingTextLabel;
@end

@implementation WPFieldReportTableViewCell

const static float CELL_HEIGHT = 61.0f;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
        
        [self createSubviews];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)dealloc {
    [self.photoView cancelImageRequestOperation];
}

#pragma mark - View Hierarchy

- (void)createSubviews {
    UIView *content = self.contentView;
    content.backgroundColor = [UIColor whiteColor];
    
    _photoView = [({
        UIImageView *photoView = [[UIImageView alloc] init];
        [photoView setContentMode:UIViewContentModeScaleAspectFill];
        [photoView setClipsToBounds:YES];
        photoView.layer.cornerRadius = 3.0;
        photoView;
    }) wp_addToSuperview:content];
    
    _dateLabel = [({
        UILabel *label = [[UILabel alloc] init];
        label;
    }) wp_addToSuperview:content];
    
    _ratingNumberLabel = [({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:28.0];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    }) wp_addToSuperview:content];
    
    _ratingTextLabel = [({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"RATING";
        label.font = [UIFont systemFontOfSize:11.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.alpha = 0.5;
        label;
    }) wp_addToSuperview:content];
}

- (void)updateConstraints {
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.width.equalTo(@40);
        make.top.equalTo(@(standardMargin));
        make.leading.equalTo(@(standardMargin));
    }];
    
    [self.dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.greaterThanOrEqualTo(@40);
        make.top.equalTo(self.photoView.mas_top);
        make.leading.equalTo(self.photoView.mas_trailing)
            .with.offset(standardMargin);
        make.trailing.equalTo(self.ratingNumberLabel.mas_leading)
            .with.offset(-standardMargin);
    }];
    
    [self.ratingNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@23);
        make.top.equalTo(@(standardMargin));
        make.leading.equalTo(self.ratingTextLabel.mas_leading);
        make.trailing.equalTo(@(-standardMargin));
    }];
    
    [self.ratingTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@10);
        make.width.greaterThanOrEqualTo(@50);
        make.bottom.equalTo(@(-standardMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];
    
    [super updateConstraints];
}

#pragma mark - Public Methods

+ (CGFloat)cellHeight { return CELL_HEIGHT; }

@end