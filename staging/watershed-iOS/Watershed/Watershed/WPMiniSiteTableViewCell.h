//
//  WPMiniSiteTableViewCell.h
//  Watershed
//
//  Created by Andrew Millman on 10/13/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPView.h"

@interface WPMiniSiteTableViewCell : UITableViewCell

@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UIImageView *photoView;
@property (nonatomic) UIView *ratingDotView;
@property (nonatomic) WPLabeledIcon *taskCountLabel;
@property (nonatomic) WPLabeledIcon *fieldReportCountLabel;

+ (CGFloat)cellHeight;

@end
