//
//  WPTaskViewController.h
//  Watershed
//
//  Created by Jordeen Chang on 10/19/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//
#import "WPTaskView.h"

#import <UIKit/UIKit.h>
#import "UIExtensions.h"

@interface WPTaskViewController : WPViewController

@property (nonatomic) NSString *taskTitle;
@property (nonatomic) NSString *taskDescription;
@property (nonatomic) NSString *dueDate;
@property (nonatomic) NSString *completed;
@property (nonatomic) NSString *assignee;
@property (nonatomic) NSString *assigner;
@property (nonatomic) WPTaskView *view;

@end
