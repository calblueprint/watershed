//
//  WPAddFieldReportTableViewCell.h
//  Watershed
//
//  Created by Jordeen Chang on 2/21/15.
//  Copyright (c) 2015 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPAddFieldReportTableViewCell : UITableViewCell

@property (nonatomic) UILabel *label;
@property (nonatomic) UIView *control;
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *) reuseIdentifier
         andControl:(UIControl *) control;

@end
