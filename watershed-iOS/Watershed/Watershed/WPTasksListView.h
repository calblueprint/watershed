//
//  WPTasksListView.h
//  Watershed
//
//  Created by Jordeen Chang on 9/28/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIExtensions.h"
#import "WPTasksListViewController.h"

@class WPTasksListViewController;

@interface WPTasksListView : WPView

- (instancetype)initWithFrame:(CGRect)frame andTableViewController:(WPTasksListViewController *)tableViewController;

@end
