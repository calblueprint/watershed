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
#import "WPLabledIcon.h"
#import "Masonry.h"

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
        //content.layer.cornerRadius = 3.0;
        [content setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = name;
        [content addSubview:nameLabel];
        
        UIImageView *photoView = [[UIImageView alloc] initWithImage:image];
        [photoView setContentMode:UIViewContentModeScaleAspectFit];
        [photoView setClipsToBounds:YES];
        photoView.layer.cornerRadius = 3.0;
        [content addSubview:photoView];
        
        UIView *ratingDotView = [[UIView alloc] init];
        ratingDotView.layer.cornerRadius = 5.0;
        ratingDotView.backgroundColor = [WPMiniSiteTableViewCell colorForRating:rating];
        [content addSubview:ratingDotView];
        
        WPLabledIcon *taskCountLabel = [[WPLabledIcon alloc] initWithText:@"4 tasks"
                                                                     icon:[UIImage imageNamed:@"CheckIcon"]];
        [self addSubview:taskCountLabel];
        
        WPLabledIcon *fieldReportCountLabel = [[WPLabledIcon alloc] initWithText:@"4 field reports"
                                                                     icon:[UIImage imageNamed:@"ExclamationIcon"]];
        [self addSubview:fieldReportCountLabel];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(CELL_HEIGHT));
            make.width.equalTo(@([[UIScreen mainScreen] bounds].size.width));
        }];
        
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.bottom.equalTo(@0);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [photoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@40);
            make.width.equalTo(@40);
            make.top.equalTo(@10);
            make.leading.equalTo(@10);
        }];
        
        [nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.greaterThanOrEqualTo(@40);
            make.top.equalTo(photoView.mas_top);
            make.left.equalTo(photoView.mas_right)
                .with.offset(10.0);
            make.trailing.equalTo(@30);
        }];
        
        [ratingDotView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
            make.width.equalTo(@10);
            make.top.equalTo(@10);
            make.trailing.equalTo(@-10);
        }];
        
        [taskCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom)
                .with.offset([[UIView wp_stylePadding] floatValue]);
            make.leading.equalTo(photoView.mas_leading);
            //make.trailing.equalTo([UIView wp_styleNegativePadding]);
        }];
        
        [fieldReportCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom)
                .with.offset([[UIView wp_stylePadding] floatValue]);
            make.leading.equalTo(taskCountLabel.mas_trailing)
                .with.offset([[UIView wp_stylePadding] floatValue]);
        }];
        
        [super updateConstraints];
        
    }
    return self;
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
