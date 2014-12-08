//
//  WPTableViewCell.h
//  Watershed
//
//  Created by Jordeen Chang on 10/12/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIExtensions.h"

@interface WPTasksTableViewCell : UITableViewCell

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *taskDescription;
@property (copy, nonatomic) NSDate *dueDate;
@property (nonatomic) Boolean *completed;

@end
