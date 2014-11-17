//
//  WPSiteViewController.m
//  Watershed
//
//  Created by Andrew Millman on 10/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSiteViewController.h"
#import "WPSiteView.h"
#import "WPMiniSiteTableViewCell.h"
#import "WPMiniSiteViewController.h"

@interface WPSiteViewController ()

@property (nonatomic) UITableView *miniSiteTableView;
@property (nonatomic) NSMutableArray *miniSiteList;

@end

static NSString *cellIdentifier = @"MiniSiteCell";

@implementation WPSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Watershed";
    [self loadMiniSiteData];
    self.miniSiteTableView.delegate = self;
    self.miniSiteTableView.dataSource = self;
}

- (void)loadView {
    WPSiteView *siteView = [[WPSiteView alloc] init];
    self.view = siteView;
    self.miniSiteTableView = siteView.miniSiteTableView;
}

- (void)loadMiniSiteData {
    self.miniSiteList = @[@1, @3, @4, @2, @5, @1, @5, @2, @2, @3, @4, @0].mutableCopy;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self isMovingToParentViewController]) {
        //view controller is being pushed on
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor clearColor]}];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self isMovingFromParentViewController]) {
        //view controller is being popped off
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
}

#pragma mark - TableView Delegate/DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rowCount = 0;
    
    if ([tableView isEqual:self.miniSiteTableView]) rowCount = self.miniSiteList.count;
    [(WPSiteView *)self.view updateTableViewHeight:self.miniSiteList.count];
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cellView = nil;
    
    if ([tableView isEqual:self.miniSiteTableView]) {
        
        cellView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cellView) {
            
            cellView = [[WPMiniSiteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:cellIdentifier
                                                                 name:@"Yes"
                                                                image:[UIImage imageNamed:@"SampleCoverPhoto2"]
                                                               rating:[self.miniSiteList[indexPath.row] intValue]
                                                            taskCount:5
                                                     fieldReportCount:5];
        }
    }
    return cellView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WPMiniSiteTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPMiniSiteViewController *miniSiteViewController = [[WPMiniSiteViewController alloc] init];
    [self.navigationController pushViewController:miniSiteViewController animated:YES];
}

@end
