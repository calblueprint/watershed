//
//  WPSitesTableViewController.m
//  Watershed
//
//  Created by Andrew Millman on 10/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSitesTableViewController.h"
#import "WPSitesTableView.h"
#import "WPSiteTableViewCell.h"
#import "WPSiteViewController.h"
#import "WPSite.h"
#import "WPNetworkingManager.h"

@interface WPSitesTableViewController () <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic) WPSitesTableView *sitesTableView;
@property (nonatomic) NSMutableArray *sitesList;
@property (nonatomic) UISearchDisplayController *searchController;
@property (nonatomic) UISearchBar *searchBar;

@end

static NSString *cellIdentifier = @"SiteCell";

@implementation WPSitesTableViewController

- (void)loadView {
    self.view = [[WPView alloc] initWithFrame:[[UIScreen mainScreen] bounds] visibleNavbar:YES];
    [[WPNetworkingManager sharedManager] requestSitesListWithParameters:[[NSMutableDictionary alloc] init] success:^(id response) {
        UIAlertView *loaded = [[UIAlertView alloc] initWithTitle:@"SUCCESS" message:@"SITES LOADED" delegate:nil cancelButtonTitle:@"K" otherButtonTitles:nil];
        [loaded show];
        [self loadSiteData:(NSDictionary *)response];
    }];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"Sites";
    
    [self setUpSearchBar];
    
    //09[self loadSiteData];
    self.sitesTableView.delegate = self;
    self.sitesTableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updatePhotoOffset:self.sitesTableView.contentOffset.y];
}

- (void)loadSiteData:(NSDictionary *)data {
    NSArray *sitesJSON = data[@"sites"];
    for (NSDictionary *siteData in sitesJSON) {
        WPSite *site = [[WPSite alloc] init];
        site.siteId = siteData[@"id"];
        site.name = siteData[@"name"];
        site.info = siteData[@"description"];
        site.latitude = [siteData[@"latitude"] floatValue];
        site.longitude = [siteData[@"longitude"] floatValue];
        site.street = siteData[@"street"];
        site.city = siteData[@"city"];
        site.state = siteData[@"state"];
        site.zipCode = siteData[@"zip_code"];
        site.miniSitesCount = [siteData[@"mini_sites_count"] intValue];
        
        [self.sitesList addObject:site];
    }
    [self.sitesTableView reloadData];
}

#pragma mark - TableView Delegate/DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

    NSInteger rowCount = 0;
    
    if ([tableView isEqual:self.sitesTableView]) rowCount = self.sitesList.count;
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cellView = nil;
    
    if ([tableView isEqual:self.sitesTableView]) {
        
        cellView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cellView) {
            WPSite *site = self.sitesList[indexPath.row];
            
            cellView = [[WPSiteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:cellIdentifier
                                                             name:site.name
                                                            image:[UIImage imageNamed:@"SampleCoverPhoto"]
                                                    miniSiteCount:site.miniSitesCount
                        ];
        }
    }
    return cellView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WPSiteTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPSiteViewController *siteViewController = [[WPSiteViewController alloc] init];
    [self.navigationController pushViewController:siteViewController animated:YES];
}

#pragma mark - ScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.sitesTableView]) {
        [self updatePhotoOffset:scrollView.contentOffset.y];
    }
    
}

- (void)updatePhotoOffset:(CGFloat)contentOffset {
    [self.sitesTableView.visibleCells makeObjectsPerformSelector:@selector(updatePhotoPosition:)
                                                      withObject:@(contentOffset)];
}

#pragma mark - Search / Search Delegate Methods

- (void)setUpSearchBar {

    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                         target:self
                                         action:@selector(openSearch) ];
    searchButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = searchButtonItem;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, topMargin, [WPView getScreenWidth], topMargin)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search Sites";
    self.searchBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.view addSubview:self.searchBar];
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
}

- (void)openSearch {
    [self.searchController setActive:YES animated:YES];
    [self.searchBar becomeFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        [self.searchBar setFrame:CGRectMake(0, 10, [WPView getScreenWidth], topMargin)];
    }];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    [self searchBarCancelButtonClicked:self.searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.2 animations:^{
        [self.searchBar setFrame:CGRectMake(0, topMargin, [WPView getScreenWidth], topMargin)];
    }];
}

#pragma mark - Lazy instantiation

- (NSMutableArray *)sitesList {
    if (!_sitesList) {
        _sitesList = [[NSMutableArray alloc] init];
    }
    return _sitesList;
}

- (WPSitesTableView *)sitesTableView {
    if (!_sitesTableView) {
        _sitesTableView = [[WPSitesTableView alloc] init];
        [self.view addSubview:_sitesTableView];
    }
    return _sitesTableView;
}



@end
