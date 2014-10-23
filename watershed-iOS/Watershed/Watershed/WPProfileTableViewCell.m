//
//  WPProfileTableViewCell.m
//  Watershed
//
//  Created by Melissa Huang on 10/19/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPProfileTableViewCell.h"

@implementation WPProfileTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self updateConstraints];
    }
    return self;
}


@end
