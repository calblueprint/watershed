//
//  WPAddTaskViewController.h
//  Watershed
//
//  Created by Jordeen Chang on 11/21/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIExtensions.h"
#import "WPSelectTaskViewController.h"
#import "WPSelectMiniSiteViewController.h"
#import "WPSelectAssigneeViewController.h"
#import "WPTasksListViewController.h"
#import "WPMiniSite.h"
#import "WPTask.h"

@interface WPAddTaskViewController : WPViewController<
    UITableViewDataSource,
    UITableViewDelegate,
    UITextFieldDelegate,
    SelectTaskDelegate,
    SelectSiteDelegate,
    SelectAssigneeDelegate
>
- (void)setTask:(WPTask *)task;

@property (nonatomic) WPTasksListViewController *parent;
@property (nonatomic) UITextField *dateField;
@property (nonatomic) UITextField *taskField;
@property (nonatomic) UITextField *siteField;
@property (nonatomic) UITextField *assigneeField;
@property (nonatomic) UITextView *descriptionView;
@property (nonatomic) WPMiniSite *selectedMiniSite;
@property (nonatomic) WPUser *selectedAssignee;
@property (nonatomic) WPUser *currUser;
@property (nonatomic) WPSite *currSite;
@property (nonatomic) UISwitch *urgentSwitch;

@end
