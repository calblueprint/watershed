//
//  WPTasksListViewController.h
//  
//
//  Created by Jordeen Chang on 9/28/14.
//
//

#import <UIKit/UIKit.h>
#import "WPMyTasksTableViewController.h"
#import "WPAllTasksTableViewController.h"

@interface WPTasksListViewController : UIViewController

@property (nonatomic) WPMyTasksTableViewController *myTasksTableController;
@property (nonatomic) WPAllTasksTableViewController * allTasksTableController;


@end
