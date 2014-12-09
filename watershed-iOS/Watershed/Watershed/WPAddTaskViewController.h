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

@interface WPAddTaskViewController : WPViewController<
    UITableViewDataSource,
    UITableViewDelegate,
    UITextFieldDelegate,
    SelectTaskDelegate,
    SelectSiteDelegate,
    SelectAssigneeDelegate
>

@end
