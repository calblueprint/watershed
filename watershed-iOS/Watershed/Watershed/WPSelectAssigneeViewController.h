//
//  WPSelectAssigneeViewController.h
//  Watershed
//
//  Created by Jordeen Chang on 11/24/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPViewController.h"
#import "WPUser.h"

@protocol SelectAssigneeDelegate <NSObject>
- (void)selectAssigneeViewControllerDismissed:(WPUser *)assignee;
@end

@interface WPSelectAssigneeViewController : WPViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<SelectAssigneeDelegate> selectAssigneeDelegate;

@property (nonatomic) NSString *assigneeName;

@end
