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
#import "WPNetworkingManager.h"
#import "WPEditMiniSiteViewController.h"
#import "WPAddFieldReportViewController.h"

@interface WPMiniSiteViewController ()

@property (nonatomic) WPMiniSiteView *view;
@property (nonatomic) UITableView *fieldReportTableView;
@property (nonatomic) NSMutableArray *fieldReportList;
@property (nonatomic) UIRefreshControl *refreshControl;

@end

static NSString *cellIdentifier = @"FieldReportCell";

@implementation WPMiniSiteViewController
@synthesize miniSite = _miniSite;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.miniSite.name;

    [self setUpRightBarButtonItems];

    self.fieldReportTableView.delegate = self;
    self.fieldReportTableView.dataSource = self;
    
    [self.refreshControl addTarget:self action:@selector(requestAndLoadMiniSite) forControlEvents:UIControlEventValueChanged];
    [self.view.miniSiteScrollView addSubview:self.refreshControl];

    [self requestAndLoadMiniSite];
}

- (void)loadView {
    self.view = [[WPMiniSiteView alloc] init];
    self.fieldReportTableView = self.view.fieldReportTableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestAndLoadMiniSite];
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

#pragma mark - Networking Methods

- (void)requestAndLoadMiniSite {
    __weak __typeof(self)weakSelf = self;
    [[WPNetworkingManager sharedManager] requestMiniSiteWithMiniSite:self.miniSite parameters:[[NSMutableDictionary alloc] init] success:^(WPMiniSite *miniSite, NSMutableArray *fieldReportList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.miniSite = miniSite;
        strongSelf.fieldReportList = fieldReportList;
        [strongSelf.fieldReportTableView reloadData];
        [strongSelf.view stopIndicator];
        [strongSelf.refreshControl endRefreshing];
    }];
}

#pragma mark - Navigation Bar Setup

- (void)setUpRightBarButtonItems {
    NSMutableArray *barButtonItems = [[NSMutableArray alloc] init];
    NSString *userRole = [WPNetworkingManager sharedManager].keyChainStore[@"role"];
    if (YES) {
        [barButtonItems insertObject:[self newAddFieldReportButtonItem] atIndex:0];
        [barButtonItems insertObject:[self newEditMiniSiteButtonItem] atIndex:1];
    }
    [self.navigationItem setRightBarButtonItems:barButtonItems animated:YES];
}

#pragma mark - Add Field Report Button / Methods

- (UIBarButtonItem *)newAddFieldReportButtonItem {
    FAKIonIcons *plusIcon = [FAKIonIcons androidAddIconWithSize:26];
    UIImage *plusImage = [plusIcon imageWithSize:CGSizeMake(24, 24)];
    UIBarButtonItem *addFieldReportButtonItem = [[UIBarButtonItem alloc] initWithImage:plusImage style:UIBarButtonItemStylePlain target:self action:@selector(addNewFieldReport)];
    addFieldReportButtonItem.tintColor = [UIColor whiteColor];
    return addFieldReportButtonItem;
}

- (void)addNewFieldReport {
    WPAddFieldReportViewController *addFieldReportViewController = [[WPAddFieldReportViewController alloc] init];
    [self.navigationController pushViewController:addFieldReportViewController animated:YES];
}

#pragma mark - Edit Mini Site Button / Methods

- (UIBarButtonItem *)newEditMiniSiteButtonItem {
    FAKIonIcons *editIcon = [FAKIonIcons androidCreateIconWithSize:24];
    UIImage *editImage = [editIcon imageWithSize:CGSizeMake(24, 24)];
    UIBarButtonItem *editMiniSiteButtonItem = [[UIBarButtonItem alloc] initWithImage:editImage style:UIBarButtonItemStylePlain target:self action:@selector(showEditMiniSiteView)];
    editMiniSiteButtonItem.tintColor = [UIColor whiteColor];
    return editMiniSiteButtonItem;
}

- (void)showEditMiniSiteView {
    WPEditMiniSiteViewController *editMiniSiteViewController = [[WPEditMiniSiteViewController alloc] init];
    editMiniSiteViewController.miniSite = self.miniSite;
    UINavigationController *editMiniSiteNavController = [[UINavigationController alloc] initWithRootViewController:editMiniSiteViewController];
    [editMiniSiteNavController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [editMiniSiteNavController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [editMiniSiteNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    [self.navigationController presentViewController:editMiniSiteNavController animated:YES completion:nil];
}

#pragma mark - TableView Delegate/DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rowCount = 0;
    
    if ([tableView isEqual:self.fieldReportTableView]) rowCount = self.fieldReportList.count;
    [self.view updateTableViewHeight:self.fieldReportList.count];
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WPFieldReportTableViewCell *cellView = nil;
    
    if ([tableView isEqual:self.fieldReportTableView]) {
        
        cellView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [cellView.photoView cancelImageRequestOperation];
        cellView.photoView.image = nil;
        
        if (!cellView) {
            cellView = [[WPFieldReportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:cellIdentifier];
        }
        WPFieldReport *fieldReport = self.fieldReportList[indexPath.row];
        [cellView.photoView setImageWithURL:[fieldReport.imageURLs firstObject]
                           placeholderImage:[UIImage imageNamed:@"WPBlue"]];
        cellView.dateLabel.text = [fieldReport dateString];
        cellView.ratingNumberLabel.text = [fieldReport.rating stringValue];
        cellView.ratingNumberLabel.textColor = [UIColor colorForRating:[fieldReport.rating intValue]];
    }
    return cellView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WPFieldReportTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPFieldReport *selectedFieldReport = self.fieldReportList[indexPath.row];
    WPFieldReportViewController *fieldReportController = [[WPFieldReportViewController alloc] init];
    fieldReportController.fieldReport = selectedFieldReport;
    [self.navigationController pushViewController:fieldReportController animated:YES];
}

#pragma mark - Setter Methods

- (void)setMiniSite:(WPMiniSite *)miniSite {
    _miniSite = miniSite;
    [self.view configureWithMiniSite:miniSite];
}

#pragma mark - Lazy Instantiation

- (NSMutableArray *)miniSiteList {
    if (!_fieldReportList) {
        _fieldReportList = [[NSMutableArray alloc] init];
    }
    return _fieldReportList;
}

- (WPMiniSite *)miniSite {
    if (!_miniSite) {
        _miniSite = [[WPMiniSite alloc] init];
    }
    return _miniSite;
}

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
    }
    return _refreshControl;
}

@end
