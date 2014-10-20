//
//  WPMiniSiteTableViewCell.m
//  Watershed
//
//  Created by Andrew on 10/13/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPMiniSiteTableViewCell.h"
#import "UIColor+WPColors.h"
#import "UIView+WPExtensions.h"
#import "WPLabeledIcon.h"
#import "Masonry.h"

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
   fieldReportCount:(NSInteger)fieldReportCount
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
        
        UIView *content = self.contentView;
        content.backgroundColor = [UIColor whiteColor];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = name;
        _nameLabel = nameLabel;
        [content addSubview:nameLabel];
        
        UIImageView *photoView = [[UIImageView alloc] initWithImage:image];
        [photoView setContentMode:UIViewContentModeScaleAspectFit];
        [photoView setClipsToBounds:YES];
        photoView.layer.cornerRadius = 3.0;
        _photoView = photoView;
        [content addSubview:photoView];
        
        UIView *ratingDotView = [[UIView alloc] init];
        ratingDotView.layer.cornerRadius = 5.0;
        ratingDotView.backgroundColor = [WPMiniSiteTableViewCell colorForRating:rating];
        _ratingDotView = ratingDotView;
        [content addSubview:ratingDotView];
        
        NSString *taskText = [NSString stringWithFormat:@"%d tasks", (int)taskCount];
        WPLabeledIcon *taskCountLabel = [[WPLabeledIcon alloc] initWithText:taskText
                                                                     icon:[UIImage imageNamed:@"CheckIcon"]];
        _taskCountLabel = taskCountLabel;
        [content addSubview:taskCountLabel];
        
        NSString *fieldReportText = [NSString stringWithFormat:@"%d reports", (int)fieldReportCount];
        WPLabeledIcon *fieldReportCountLabel = [[WPLabeledIcon alloc] initWithText:fieldReportText
                                                                     icon:[UIImage imageNamed:@"ExclamationIcon"]];
        _fieldReportCountLabel = fieldReportCountLabel;
        [content addSubview:fieldReportCountLabel];
        
        [self updateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight { return CELL_HEIGHT; }

+ (UIColor *)colorForRating:(NSInteger)rating
{
    switch (rating) {
        case 1:
            return [UIColor colorWithRed:231/255.0 green:76/255.0 blue:60/255.0 alpha:1];
            break;
            
        case 2:
            return [UIColor colorWithRed:230/255.0 green:126/255.0 blue:34/255.0 alpha:1];
            break;
            
        case 3:
            return [UIColor colorWithRed:241/255.0 green:196/255.0 blue:15/255.0 alpha:1];
            break;
            
        case 4:
            return [UIColor colorWithRed:164/255.0 green:196/255.0 blue:0/255.0 alpha:1];
            break;
            
        case 5:
            return [UIColor colorWithRed:39/255.0 green:174/255.0 blue:96/255.0 alpha:1];
            break;
        default:
            break;
    }
    return [UIColor grayColor];
}

@end
