//
//  WPAddTaskTableViewCell.h
//  Watershed
//
//  Created by Jordeen Chang on 11/22/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPAddTaskTableViewCell : UITableViewCell

@property (nonatomic) UILabel *label;
@property (nonatomic) UIControl *control;
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *) reuseIdentifier
         andControl:(UIControl *) control;
@end
