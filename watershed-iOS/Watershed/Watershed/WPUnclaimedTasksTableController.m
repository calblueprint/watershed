//
//  WPUnclaimedTasksTableController.m
//  Watershed
//
//  Created by Jordeen Chang on 4/26/15.
//  Copyright (c) 2015 Blueprint. All rights reserved.
//

#import "WPUnclaimedTasksTableController.h"
#import "WPTasksTableViewCell.h"
#import "WPNetworkingManager.h"
#import "WPTaskViewController.h"
#import "WPMyTasksTableView.h"

@interface WPUnclaimedTasksTableController ()

@property (nonatomic) WPMyTasksTableView *tableView;
@property (nonatomic) WPUser *user;
@end

@implementation WPUnclaimedTasksTableController


#pragma mark - Networking Methods

- (void)requestAndLoadMyTasks {
    
    _user = [[WPUser alloc] init];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    _user.userId = [f numberFromString:[[WPNetworkingManager sharedManager] keyChainStore][@"user_id"]];
    [[WPNetworkingManager sharedManager] requestUserWithUser:_user parameters:[[NSMutableDictionary alloc] init] success:^(WPUser *user) {
        _user = user;
    }];

    __weak __typeof(self)weakSelf = self;
    [[WPNetworkingManager sharedManager] requestTasksListWithParameters:[[NSMutableDictionary alloc] init] success:^(NSMutableArray *tasksList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSMutableArray *toBeRemoved = [[NSMutableArray alloc] init];
        for (WPTask *t in tasksList) {
            if (t.miniSite.site.siteId) {
                [toBeRemoved addObject:t];
            }
        }
        [tasksList removeObjectsInArray:toBeRemoved];
        strongSelf.tasks = tasksList;
        [strongSelf.tableView reloadData];
        [self.tableView stopIndicator];
        [self.refreshControl endRefreshing];
    }];
}

@end
