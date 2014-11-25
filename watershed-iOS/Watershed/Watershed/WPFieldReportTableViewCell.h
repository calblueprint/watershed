//
//  WPFieldReportTableViewCell.h
//  Watershed
//
//  Created by Andrew Millman on 11/3/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPView.h"

@interface WPFieldReportTableViewCell : UITableViewCell

@property (nonatomic) UIImageView *photoView;
@property (nonatomic) UILabel *dateLabel;
@property (nonatomic) UILabel *ratingNumberLabel;
@property (nonatomic) UILabel *ratingTextLabel;

+ (CGFloat)cellHeight;

@end
