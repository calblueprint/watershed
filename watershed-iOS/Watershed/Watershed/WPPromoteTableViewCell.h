//
//  WPPromoteTableViewCell.h
//  Watershed
//
//  Created by Jordeen Chang on 5/3/15.
//  Copyright (c) 2015 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPPromoteTableViewCell : UITableViewCell

@property (nonatomic) UILabel *userLabel;
@property (nonatomic) UIButton *promoteButton;

- (void)addSubviews;

@end
