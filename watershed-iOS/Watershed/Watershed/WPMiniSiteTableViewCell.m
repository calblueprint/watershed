//
//  WPMiniSiteTableViewCell.m
//  Watershed
//
//  Created by Andrew on 10/13/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPMiniSiteTableViewCell.h"
#import "UIColor+WPColors.h"
#import "WPLabledIcon.h"

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
        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
