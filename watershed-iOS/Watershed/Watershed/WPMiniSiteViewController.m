//
//  WPMiniSiteViewController.m
//  Watershed
//
//  Created by Andrew Millman on 11/2/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPMiniSiteViewController.h"
#import "WPMiniSiteView.h"
#import "WPFieldReportTableViewCell.h"
#import "WPFieldReportViewController.h"

@interface WPMiniSiteViewController ()

@property (nonatomic) UITableView *fieldReportTableView;
@property (nonatomic) NSMutableArray *fieldReportList;

@end

static NSString *cellIdentifier = @"FieldReportCell";

@implementation WPMiniSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Mini Site";
    [self loadFieldReportData];
    self.fieldReportTableView.delegate = self;
    self.fieldReportTableView.dataSource = self;
}

- (void)loadView {
    WPMiniSiteView *miniSiteView = [[WPMiniSiteView alloc] init];
    self.view = miniSiteView;
    self.fieldReportTableView = miniSiteView.fieldReportTableView;
}

- (void)loadFieldReportData {
    self.fieldReportList = @[@1, @3, @4, @2, @5, @1, @5, @2, @2, @3, @4, @0].mutableCopy;
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
    
    if ([tableView isEqual:self.fieldReportTableView]) rowCount = self.fieldReportList.count;
    [(WPMiniSiteView *)self.view updateTableViewHeight:self.fieldReportList.count];
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cellView = nil;
    
    if ([tableView isEqual:self.fieldReportTableView]) {
        
        cellView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cellView) {
            
            cellView = [[WPFieldReportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:cellIdentifier
                                                                   image:[UIImage imageNamed:@"SampleCoverPhoto"]
                                                                    date:@"Oct 1, 2015"
                                                                  rating:[self.fieldReportList[indexPath.row] intValue]
                                                                  urgent:YES];
        }
    }
    return cellView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WPFieldReportTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPFieldReportViewController *fieldReportController = [[WPFieldReportViewController alloc] init];
    [self.navigationController pushViewController:fieldReportController animated:YES];
}

@end
