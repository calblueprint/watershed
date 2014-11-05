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
}

- (void)updateConstraints {
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