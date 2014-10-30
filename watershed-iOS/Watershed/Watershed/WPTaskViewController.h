//
//  WPTaskViewController.h
//  Watershed
//
//  Created by Jordeen Chang on 10/19/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//
#import "WPTaskView.h"

#import <UIKit/UIKit.h>

@interface WPTaskViewController : UIViewController

@property (nonatomic, strong) NSString *taskTitle;
@property (nonatomic, strong) NSString *taskDescription;
@property (nonatomic, strong) NSString *dueDate;
@property (nonatomic, strong) NSString *completed;
@property (nonatomic) WPTaskView *view;

@end
