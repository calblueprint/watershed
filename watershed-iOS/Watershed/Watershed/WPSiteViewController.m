//
//  WPSiteViewController.m
//  Watershed
//
//  Created by Andrew Millman on 10/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSiteViewController.h"
#import "WPSiteView.h"
#import "WPMiniSite.h"
#import "WPMiniSiteTableViewCell.h"
#import "WPMiniSiteViewController.h"
#import "WPCreateMiniSiteViewController.h"
#import "WPEditSiteViewController.h"
#import "WPNetworkingManager.h"

@interface WPSiteViewController ()

@property (nonatomic) WPSiteView *view;
@property (nonatomic) UITableView *miniSiteTableView;
@property (nonatomic) NSMutableArray *miniSiteList;
@property (nonatomic) UIRefreshControl *refreshControl;

@end

static NSString *cellIdentifier = @"MiniSiteCell";

@implementation WPSiteViewController
@synthesize site = _site;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.site.name;
    
    [self setUpRightBarButtonItems];
    
    self.miniSiteTableView.delegate = self;
    self.miniSiteTableView.dataSource = self;

    [self.refreshControl addTarget:self action:@selector(requestAndLoadSite) forControlEvents:UIControlEventValueChanged];
    [self.view.siteScrollView addSubview:self.refreshControl];
}

- (void)loadView {
    self.view = [[WPSiteView alloc] init];
    self.miniSiteTableView = self.view.miniSiteTableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.isDismissing) {
        [self requestAndLoadSite];
    }
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
    [self.view updateTableViewHeight:self.miniSiteList.count];
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WPMiniSiteTableViewCell *cellView = nil;
    
    if ([tableView isEqual:self.miniSiteTableView]) {
        
        cellView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [cellView.photoView cancelImageRequestOperation];
        cellView.photoView.image = nil;
        
        if (!cellView) {
            
            cellView = [[WPMiniSiteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:cellIdentifier];
        }
        WPMiniSite *miniSite = self.miniSiteList[indexPath.row];
        cellView.nameLabel.text = miniSite.name;
        [cellView.photoView setImageWithURL:[miniSite.imageURLs firstObject]
                           placeholderImage:[UIImage imageNamed:@"WPBlue"]];
        cellView.ratingDotView.backgroundColor = [UIColor colorForRating:[miniSite.healthRating intValue]];
        cellView.taskCountLabel.label.text = [NSString stringWithFormat:@"%@ tasks", miniSite.taskCount];
        cellView.fieldReportCountLabel.label.text = [[miniSite.fieldReportCount stringValue] stringByAppendingString:@" field reports"];
    }
    return cellView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WPMiniSiteTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPMiniSite *selectedMiniSite = self.miniSiteList[indexPath.row];
    WPMiniSiteViewController *miniSiteViewController = [[WPMiniSiteViewController alloc] init];
    miniSiteViewController.miniSite = selectedMiniSite;
    [self.navigationController pushViewController:miniSiteViewController animated:YES];
}

#pragma mark - Networking Methods

- (void)requestAndLoadSite {
    __weak __typeof(self)weakSelf = self;
    [[WPNetworkingManager sharedManager] requestSiteWithSite:self.site parameters:[[NSMutableDictionary alloc] init] success:^(WPSite *site, NSMutableArray *miniSiteList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.site = site;
        strongSelf.miniSiteList = miniSiteList;
        [strongSelf.miniSiteTableView reloadData];
        [strongSelf.view stopIndicator];
        [strongSelf.refreshControl endRefreshing];
    }];
}

#pragma mark - Navigation Bar Setup

- (void)setUpRightBarButtonItems {
    NSMutableArray *barButtonItems = [[NSMutableArray alloc] init];
    NSString *userRole = [WPNetworkingManager sharedManager].keyChainStore[@"role"];
    if (YES) {
        [barButtonItems insertObject:[self newAddSiteButtonItem] atIndex:0];
        [barButtonItems insertObject:[self newEditSiteButtonItem] atIndex:1];
    }
    [self.navigationItem setRightBarButtonItems:barButtonItems animated:YES];
}

#pragma mark - Add Site Button / Methods

- (UIBarButtonItem *)newAddSiteButtonItem {
    FAKIonIcons *plusIcon = [FAKIonIcons androidAddIconWithSize:26];
    UIImage *plusImage = [plusIcon imageWithSize:CGSizeMake(24, 24)];
    UIBarButtonItem *addMiniSiteButtonItem = [[UIBarButtonItem alloc] initWithImage:plusImage style:UIBarButtonItemStylePlain target:self action:@selector(showCreateMiniSiteView)];
    addMiniSiteButtonItem.tintColor = [UIColor whiteColor];
    return addMiniSiteButtonItem;
}

- (void)showCreateMiniSiteView {
    WPCreateMiniSiteViewController *createMiniSiteViewController = [[WPCreateMiniSiteViewController alloc] init];
    createMiniSiteViewController.parent = self;
    UINavigationController *createMiniSiteNavController = [[UINavigationController alloc] initWithRootViewController:createMiniSiteViewController];
    [createMiniSiteNavController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [createMiniSiteNavController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [createMiniSiteNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    [self.navigationController presentViewController:createMiniSiteNavController animated:YES completion:nil];
}

#pragma mark - Edit Site Button / Methods

- (UIBarButtonItem *)newEditSiteButtonItem {
    FAKIonIcons *editIcon = [FAKIonIcons androidCreateIconWithSize:24];
    UIImage *editImage = [editIcon imageWithSize:CGSizeMake(24, 24)];
    UIBarButtonItem *editSiteButtonItem = [[UIBarButtonItem alloc] initWithImage:editImage style:UIBarButtonItemStylePlain target:self action:@selector(showEditSiteView)];
    editSiteButtonItem.tintColor = [UIColor whiteColor];
    return editSiteButtonItem;
}

- (void)showEditSiteView {
    WPEditSiteViewController *editSiteViewController = [[WPEditSiteViewController alloc] init];
    editSiteViewController.site = self.site;
    editSiteViewController.delegate = self;
    UINavigationController *editSiteNavController = [[UINavigationController alloc] initWithRootViewController:editSiteViewController];
    [editSiteNavController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [editSiteNavController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [editSiteNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    [self.navigationController presentViewController:editSiteNavController animated:YES completion:nil];
}

#pragma mark - Setter Methods

- (void)setSite:(WPSite *)site {
    _site = site;
    self.title = site.name;
    [self.view configureWithSite:site];
}

#pragma mark - Lazy Instantiation

- (NSMutableArray *)miniSiteList {
    if (!_miniSiteList) {
        _miniSiteList = [[NSMutableArray alloc] init];
    }
    return _miniSiteList;
}

- (WPSite *)site {
    if (!_site) {
        _site = [[WPSite alloc] init];
    }
    return _site;
}

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
    }
    return _refreshControl;
}

@end
