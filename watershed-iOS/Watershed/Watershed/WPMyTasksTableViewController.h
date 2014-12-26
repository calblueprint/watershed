//
//  WPMyTasksTableViewController.h
//  Watershed
//
//  Created by Jordeen Chang on 10/14/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPMyTasksTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (copy, nonatomic) NSArray *tasks;
- (void)requestAndLoadMyTasks;

@end
