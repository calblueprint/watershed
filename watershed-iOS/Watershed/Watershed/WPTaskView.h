//
//  WPTaskView.h
//  Watershed
//
//  Created by Jordeen Chang on 10/19/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIExtensions.h"
#import "WPTask.h"

@interface WPTaskView : WPView

@property (nonatomic) UILabel *title;
@property (nonatomic) UILabel *taskDescription;
@property (nonatomic) UILabel *dueDate;
@property (nonatomic) UILabel *assigneeLabel;
@property (nonatomic) UIButton *completed;
@property (nonatomic) UIButton *addFieldReportButton;
@property (nonatomic) UIButton *siteLinkButton;
@property (nonatomic) WPTask *task;

- (void)configureWithTask:(WPTask *)task;

@end
