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
        UIView *content = self.contentView;
        [content setBackgroundColor:[UIColor wp_blue]];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = name;
        [content addSubview:nameLabel];
        
        UIImageView *photoView = [[UIImageView alloc] initWithImage:image];
        [photoView setContentMode:UIViewContentModeScaleAspectFit];
        [content addSubview:photoView];
        
        UIView *ratingDotView = [[UIView alloc] init];
        ratingDotView.layer.cornerRadius = 5.0;
        ratingDotView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        [content addSubview:ratingDotView];
        
        WPLabledIcon *taskCountLabel = [[WPLabledIcon alloc] initWithText:@"4 tasks"
                                                                     icon:[UIImage imageNamed:@"TreeIcon"]];
        [content addSubview:taskCountLabel];
        
        WPLabledIcon *fieldReportCountLabel = [[WPLabledIcon alloc] initWithText:@"4 field reports"
                                                                     icon:[UIImage imageNamed:@"TreeIcon"]];
        [content addSubview:fieldReportCountLabel];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@100);
        }];
        
        [photoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@40);
            make.top.equalTo(@0);
            make.leading.equalTo(@0);
        }];
        
        [nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.leading.equalTo(photoView.mas_right);
            make.trailing.equalTo(@30);
        }];
        
        [ratingDotView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
            make.width.equalTo(@10);
            make.top.equalTo(@10);
            make.trailing.equalTo(@10);
        }];
        
        [taskCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom)
                .with.offset([[UIView wp_stylePadding] floatValue] / 2);
            make.leading.equalTo([UIView wp_stylePadding]);
            make.trailing.equalTo([UIView wp_styleNegativePadding]);
        }];
        
        [fieldReportCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(taskCountLabel.mas_bottom)
                .with.offset([[UIView wp_stylePadding] floatValue] / 2);
            make.leading.equalTo([UIView wp_stylePadding]);
            make.trailing.equalTo([UIView wp_styleNegativePadding]);
        }];
        
        [self updateConstraints];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
