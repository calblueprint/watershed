//
//  WPEditTaskViewController.h
//  Watershed
//
//  Created by Jordeen Chang on 4/12/15.
//  Copyright (c) 2015 Blueprint. All rights reserved.
//

#import "WPAddTaskViewController.h"
#import "WPTask.h"
#import "WPTaskViewController.h"

@interface WPEditTaskViewController : WPAddTaskViewController

@property (nonatomic) WPTask *task;
@property (nonatomic) WPTaskViewController *taskParent;

- (void)setTask:(WPTask *)task;

@end
