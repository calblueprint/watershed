//
//  WPAllTasksTableViewController.h
//  Watershed
//
//  Created by Jordeen Chang on 10/14/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPAllTasksTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (copy, nonatomic) NSArray *allTasks;

@end
