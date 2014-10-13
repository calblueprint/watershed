//
//  WPTasksListViewController.h
//  
//
//  Created by Jordeen Chang on 9/28/14.
//
//

#import <UIKit/UIKit.h>

@interface WPTasksListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (copy, nonatomic) NSArray *tasks;

@end
