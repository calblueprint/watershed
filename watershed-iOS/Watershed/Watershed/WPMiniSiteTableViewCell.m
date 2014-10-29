//
//  WPMiniSiteTableViewCell.m
//  Watershed
//
//  Created by Andrew Millman on 10/13/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPMiniSiteTableViewCell.h"

@interface WPMiniSiteTableViewCell()

@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UIImageView *photoView;
@property (nonatomic) UIView *ratingDotView;
@property (nonatomic) WPLabeledIcon *taskCountLabel;
@property (nonatomic) WPLabeledIcon *fieldReportCountLabel;
@end

@implementation WPMiniSiteTableViewCell

const static float CELL_HEIGHT = 86.0f;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
               name:(NSString *)name
              image:(UIImage *)image
             rating:(NSInteger)rating
          taskCount:(NSInteger)taskCount
   fieldReportCount:(NSInteger)fieldReportCount {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
        
        UIView *content = self.contentView;
        content.backgroundColor = [UIColor whiteColor];
        
        _nameLabel = [({
            UILabel *label = [[UILabel alloc] init];
            label.text = name;
            label;
        }) wp_addToSuperview:content];
        
        _photoView = [({
            UIImageView *photoView = [[UIImageView alloc] initWithImage:image];
            [photoView setContentMode:UIViewContentModeScaleAspectFit];
            [photoView setClipsToBounds:YES];
            photoView.layer.cornerRadius = 3.0;
            photoView;
        }) wp_addToSuperview:content];
        
        _ratingDotView = [({
            UIView *ratingDotView = [[UIView alloc] init];
            ratingDotView.layer.cornerRadius = 5.0;
            ratingDotView.backgroundColor = [WPMiniSiteTableViewCell colorForRating:rating];
            ratingDotView;
        }) wp_addToSuperview:content];
        
        _taskCountLabel = [({
            NSString *taskText = [NSString stringWithFormat:@"%d tasks", (int)taskCount];
            WPLabeledIcon *taskCountLabel = [[WPLabeledIcon alloc] initWithText:taskText
                                                                           icon:[UIImage imageNamed:@"CheckIcon"]];
            taskCountLabel.alpha = 0.3;
            taskCountLabel;
        }) wp_addToSuperview:content];
        
        _fieldReportCountLabel = [({
            NSString *fieldReportText = [NSString stringWithFormat:@"%d reports", (int)fieldReportCount];
            WPLabeledIcon *fieldReportCountLabel = [[WPLabeledIcon alloc] initWithText:fieldReportText
                                                                                  icon:[UIImage imageNamed:@"ExclamationIcon"]];
            fieldReportCountLabel.alpha = 0.3;
            fieldReportCountLabel;
        }) wp_addToSuperview:content];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
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
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.greaterThanOrEqualTo(@40);
        make.top.equalTo(self.photoView.mas_top);
        make.left.equalTo(self.photoView.mas_right)
            .with.offset(10.0);
        make.trailing.equalTo(self.ratingDotView.mas_leading).with.offset([[UIView wp_styleNegativePadding] floatValue]);
    }];
    
    [self.ratingDotView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@10);
        make.width.equalTo(@10);
        make.top.equalTo(@10);
        make.trailing.equalTo(@-10);
    }];
    
    [self.taskCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom)
            .with.offset([[UIView wp_stylePadding] floatValue]);
        make.leading.equalTo(self.photoView.mas_leading);
    }];
    
    [self.fieldReportCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom)
            .with.offset([[UIView wp_stylePadding] floatValue]);
        make.leading.equalTo(self.taskCountLabel.mas_trailing)
            .with.offset([[UIView wp_stylePadding] floatValue]);
    }];
    
    [super updateConstraints];
}

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
