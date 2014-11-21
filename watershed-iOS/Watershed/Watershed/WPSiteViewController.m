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

@property (nonatomic) UITableView *miniSiteTableView;
@property (nonatomic) NSMutableArray *miniSiteList;

@end

static NSString *cellIdentifier = @"MiniSiteCell";

@implementation WPSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.site.name;
    self.miniSiteTableView.delegate = self;
    self.miniSiteTableView.dataSource = self;

    [[WPNetworkingManager sharedManager] requestSiteWithSite:self.site parameters:[[NSMutableDictionary alloc] init] success:^(id response) {
        [self loadMiniSiteData:(NSMutableDictionary *)response];
    }];
}

- (void)loadView {
    WPSiteView *siteView = [[WPSiteView alloc] init];
    self.view = siteView;
    siteView.coverPhotoView.image = [UIImage imageNamed:@"SampleCoverPhoto2"];
    siteView.titleLabel.text = self.site.name;
    siteView.descriptionLabel.text = self.site.info;
    siteView.addressLabel.label.text = [NSString stringWithFormat:@"%@, %@, %@ %@", self.site.street, self.site.city, self.site.state, self.site.zipCode];
    siteView.siteCountLabel.label.text = [[@(self.site.miniSitesCount) stringValue] stringByAppendingString:@" mini sites"];
    
    self.miniSiteTableView = siteView.miniSiteTableView;
}

- (void)loadMiniSiteData:(NSMutableDictionary *)data {
    NSArray *miniSites = data[@"site"][@"mini_sites"];
    
    for (NSDictionary *miniSiteData in miniSites) {
        WPMiniSite *miniSite = [[WPMiniSite alloc] init];
        miniSite.miniSiteId = miniSiteData[@"id"];
        miniSite.name = miniSiteData[@"name"];
        miniSite.info = miniSiteData[@"info"];
        miniSite.latitude = [miniSiteData[@"latitude"] floatValue];
        miniSite.longitude = [miniSiteData[@"longitude"] floatValue];
        miniSite.street = miniSiteData[@"street"];
        miniSite.city = miniSiteData[@"city"];
        miniSite.state = miniSiteData[@"state"];
        miniSite.zipCode = miniSiteData[@"zip_code"];
        miniSite.image = [UIImage imageNamed:@"SampleCoverPhoto2"];
        miniSite.site = self.site;
        
        [self.miniSiteList addObject:miniSite];
    }
    [self.miniSiteTableView reloadData];
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

#pragma mark - Lazy Instantiation

- (WPSite *)site {
    if (!_site) {
        _site = [[WPSite alloc] init];
    }
    return _site;
}

@end
