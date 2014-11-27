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
#import "WPNetworkingManager.h"

@interface WPSiteViewController ()

@property (nonatomic) WPSiteView *view;
@property (nonatomic) UITableView *miniSiteTableView;
@property (nonatomic) NSMutableArray *miniSiteList;

@end

static NSString *cellIdentifier = @"MiniSiteCell";

@implementation WPSiteViewController
@synthesize site = _site;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.site.name;
    self.miniSiteTableView.delegate = self;
    self.miniSiteTableView.dataSource = self;

    [[WPNetworkingManager sharedManager] requestSiteWithSite:self.site parameters:[[NSMutableDictionary alloc] init] success:^(WPSite *site, NSMutableArray *miniSiteList) {
        self.site = site;
        self.miniSiteList = miniSiteList;
        [self.miniSiteTableView reloadData];
    }];
}

- (void)loadView {
    self.view = [[WPSiteView alloc] init];
    self.miniSiteTableView = self.view.miniSiteTableView;
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
        if (!cellView) {
            
            cellView = [[WPMiniSiteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:cellIdentifier];
        }
        WPMiniSite *miniSite = self.miniSiteList[indexPath.row];
        cellView.nameLabel.text = miniSite.name;
        cellView.photoView.image = miniSite.image;
        cellView.ratingDotView.backgroundColor = [UIColor colorForRating:3];
        cellView.taskCountLabel.label.text = [NSString stringWithFormat:@" %d tasks", 5];
        cellView.fieldReportCountLabel.label.text = [NSString stringWithFormat:@" %d field reports", 5];
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

- (void)updateSiteView {
    self.view.originalCoverPhoto = self.site.image;
    self.view.coverPhotoView.image = self.view.originalCoverPhoto;
    self.view.titleLabel.text = self.site.name;
    self.view.descriptionLabel.text = self.site.info;
    self.view.addressLabel.label.text = [NSString stringWithFormat:@"%@, %@, %@ %@", self.site.street, self.site.city, self.site.state, self.site.zipCode];
    self.view.siteCountLabel.label.text = [[self.site.miniSitesCount stringValue] stringByAppendingString:@" mini sites"];
}

#pragma mark - Setter Methods

- (void)setSite:(WPSite *)site {
    _site = site;
    [self updateSiteView];
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

@end
