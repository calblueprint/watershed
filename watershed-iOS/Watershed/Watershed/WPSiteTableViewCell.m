//
//  WPSiteTableViewCell.m
//  Watershed
//
//  Created by Andrew on 10/26/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSiteTableViewCell.h"

@implementation WPSiteTableViewCell

const static float CELL_HEIGHT = 150.0f;

+ (CGFloat)cellHeight { return CELL_HEIGHT; }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
