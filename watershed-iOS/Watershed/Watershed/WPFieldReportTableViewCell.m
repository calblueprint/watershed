//
//  WPFieldReportTableViewCell.m
//  Watershed
//
//  Created by Andrew Millman on 11/3/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPFieldReportTableViewCell.h"

@interface WPFieldReportTableViewCell()

@property (nonatomic) UIImageView *photoView;
@property (nonatomic) UILabel *dateLabel;
@property (nonatomic) UILabel *ratingNumberLabel;
@property (nonatomic) UILabel *ratingTextLabel;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSString *date;
@property (nonatomic) NSInteger rating;
@property (nonatomic) BOOL urgent;

@end

@implementation WPFieldReportTableViewCell

const static float CELL_HEIGHT = 60.0f;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
              image:(UIImage *)image
               date:(NSString *)date
             rating:(NSInteger)rating
             urgent:(BOOL)urgent {
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
        
        _image = image;
        _date = date;
        _rating = rating;
        _urgent = urgent;
        
        [self createSubviews];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)createSubviews {
    UIView *content = self.contentView;
    content.backgroundColor = [UIColor whiteColor];
    
    _photoView = [({
        UIImageView *photoView = [[UIImageView alloc] initWithImage:self.image];
        [photoView setContentMode:UIViewContentModeScaleAspectFill];
        [photoView setClipsToBounds:YES];
        photoView.layer.cornerRadius = 3.0;
        photoView;
    }) wp_addToSuperview:content];
    
    _dateLabel = [({
        UILabel *label = [[UILabel alloc] init];
        label.text = self.date;
        label;
    }) wp_addToSuperview:content];
    
    _ratingNumberLabel = [({
        UILabel *label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"%d", (int)self.rating];
        label.font = [UIFont systemFontOfSize:27.0];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    }) wp_addToSuperview:content];
    
    _ratingTextLabel = [({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"RATING";
        label.font = [UIFont systemFontOfSize:12.0];
        label.textAlignment = NSTextAlignmentCenter;
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
        make.top.equalTo(@10);
        make.leading.equalTo(@10);
    }];
    
    [self.dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.greaterThanOrEqualTo(@40);
        make.top.equalTo(self.photoView.mas_top);
        make.left.equalTo(self.photoView.mas_right)
            .with.offset(10.0);
        make.trailing.equalTo(self.ratingNumberLabel.mas_leading).with.offset([[UIView wp_styleNegativePadding] floatValue]);
    }];
    
    [self.ratingNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.top.equalTo(@10);
        make.trailing.equalTo(@-10);
    }];
    
    [self.ratingTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@10);
        make.trailing.equalTo(@-10);
    }];
    
    [super updateConstraints];
}

#pragma mark - UIView Modifications

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (CGFloat)cellHeight { return CELL_HEIGHT; }

+ (UIColor *)colorForRating:(NSInteger)rating {
    switch (rating) {
        case 1:
            return [UIColor wp_red];
            break;
            
        case 2:
            return [UIColor wp_orange];
            break;
            
        case 3:
            return [UIColor wp_yellow];
            break;
            
        case 4:
            return [UIColor wp_lime];
            break;
            
        case 5:
            return [UIColor wp_green];
            break;
        default:
            return [UIColor grayColor];
            break;
    }
}

@end