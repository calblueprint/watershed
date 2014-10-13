//
//  WPTableViewCell.m
//  Watershed
//
//  Created by Jordeen Chang on 10/12/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTableViewCell.h"

@implementation WPTableViewCell {
    UILabel *titleLabel;
    UILabel *taskDescriptionLabel;
    UILabel *dueDateLabel;
    UILabel *completedLabel;
}

- (void)awakeFromNib {
    // Initialization code
    CGRect titleRect = CGRectMake(0, 5, 70, 15);
    UILabel *titleL = [[UILabel alloc] initWithFrame:titleRect];
    titleL.textAlignment = NSTextAlignmentLeft;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
