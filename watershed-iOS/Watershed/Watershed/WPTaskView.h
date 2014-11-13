//
//  WPTaskView.h
//  Watershed
//
//  Created by Jordeen Chang on 10/19/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIExtensions.h"

@interface WPTaskView : WPView

@property (nonatomic) UILabel *title;
@property (nonatomic) UILabel *taskDescription;
@property (nonatomic) UILabel *dueDate;
@property (nonatomic) UILabel *assignee;
@property (nonatomic) UIButton *completed;
@property (nonatomic) UIButton *addFieldReportButton;

@end
