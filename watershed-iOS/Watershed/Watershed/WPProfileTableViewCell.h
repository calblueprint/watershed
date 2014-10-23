//
//  WPProfileTableViewCell.h
//  Watershed
//
//  Created by Melissa Huang on 10/19/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPProfile.h"

@interface WPProfileTableViewCell : UITableViewCell

@property UIImageView *iconImageView;
@property UILabel *infoLabel;

- (void)addSubviews;

@end
