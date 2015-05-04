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
@property (nonatomic) NSMutableArray *sites;
@property (nonatomic) NSNumber *userId;
@end

@implementation WPUnclaimedTasksTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestAndLoadMyTasks];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self requestAndLoadMyTasks];
}

#pragma mark - Networking Methods

- (void)getUser {
    NSNumberFormatter *userFormatter = [[NSNumberFormatter alloc] init];
    [userFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    _userId = [userFormatter numberFromString:[[WPNetworkingManager sharedManager] keyChainStore][@"user_id"]];
}

- (void)requestAndLoadMySites {
    __weak __typeof(self)weakSelf = self;
    [[WPNetworkingManager sharedManager] requestMySitesListWithUser:_userId parameters: [[NSMutableDictionary alloc] init] success:^(NSMutableArray *sites) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        for (WPSite *s in sites) {
            [strongSelf.sites addObject:s.siteId];
        }
    }];
}


- (void)requestAndLoadMyTasks {
    [self getUser];
    [self requestAndLoadMySites];

    __weak __typeof(self)weakSelf = self;
    [[WPNetworkingManager sharedManager] requestTasksListWithParameters:[[NSMutableDictionary alloc] init] success:^(NSMutableArray *tasksList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        NSMutableArray *toBeRemoved = [[NSMutableArray alloc] init];
        for (WPTask *t in tasksList) {
            if ([strongSelf.sites indexOfObject:t.miniSite.site.siteId] != 0 ||  t.assignee != nil || [strongSelf.sites count] == 0) {
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
