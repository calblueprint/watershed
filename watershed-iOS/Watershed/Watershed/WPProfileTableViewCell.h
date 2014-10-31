//
//  WPProfileTableViewCell.h
//  Watershed
//
//  Created by Melissa Huang on 10/19/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPProfileTableViewCell : UITableViewCell

@property (nonatomic) UIImageView *iconImageView;
@property (nonatomic) UILabel *infoLabel;

- (void)addSubviews;

@end
