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
#import "WPCreateSiteViewController.h"
#import "WPSite.h"
#import "WPNetworkingManager.h"

@interface WPSitesTableViewController () <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic) WPSitesTableView *sitesTableView;
@property (nonatomic) UISearchDisplayController *searchController;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) UIRefreshControl *refreshControl;

@end

static NSString *cellIdentifier = @"SiteCell";

@implementation WPSitesTableViewController

- (void)loadView {
    self.view = [[WPView alloc] initWithFrame:[[UIScreen mainScreen] bounds] visibleNavbar:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"Sites";
    
    [self setUpRightBarButtonItems];
    
    self.sitesTableView.delegate = self;
    self.sitesTableView.dataSource = self;

    [self.refreshControl addTarget:self action:@selector(requestAndLoadSites) forControlEvents:UIControlEventValueChanged];
    [self.sitesTableView addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestAndLoadSites];
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
    
    WPSiteTableViewCell *cellView = nil;
    
    if ([tableView isEqual:self.sitesTableView]) {
        
        cellView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [cellView.photoView cancelImageRequestOperation];
        cellView.photoView.image = nil;
        
        if (!cellView) {
            cellView = [[WPSiteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:cellIdentifier];
        }
        WPSite *site = self.sitesList[indexPath.row];
        cellView.nameLabel.text = site.name;

        __weak __typeof(cellView.photoView)weakPhotoView = cellView.photoView;
        [cellView.photoView setImageWithURLRequest:[NSURLRequest requestWithURL:[site.imageURLs firstObject]] placeholderImage:[UIImage imageNamed:@"WPBlue" ] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            __weak __typeof(weakPhotoView)strongPhotoView = weakPhotoView;
            strongPhotoView.image = image;
            [self updatePhotoOffset:self.sitesTableView.contentOffset.y];
        } failure:nil];
        
        cellView.miniSiteLabel.text = [[site.miniSitesCount stringValue] stringByAppendingString:@" mini sites"];
    }
    return cellView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WPSiteTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPSite *selectedSite = self.sitesList[indexPath.row];
    WPSiteViewController *siteViewController = [[WPSiteViewController alloc] init];
    siteViewController.site = selectedSite;
    [self.navigationController pushViewController:siteViewController animated:YES];
}

#pragma mark - Networking Methods

- (void)requestAndLoadSites {
    __weak __typeof(self)weakSelf = self;
    [[WPNetworkingManager sharedManager] requestSitesListWithParameters:[[NSMutableDictionary alloc] init] success:^(NSMutableArray *sitesList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.sitesList = sitesList;
        [strongSelf.sitesTableView reloadData];
        [strongSelf.sitesTableView stopIndicator];
        [strongSelf.refreshControl endRefreshing];
    }];
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

#pragma mark - Navigation Bar Setup

- (void)setUpRightBarButtonItems {
    NSMutableArray *barButtonItems = [[NSMutableArray alloc] initWithObjects:[self newSearchBarButtonItem], nil];
    NSString *userRole = [WPNetworkingManager sharedManager].keyChainStore[@"role"];
    if ([userRole isEqual:@"2"]) {
        [barButtonItems insertObject:[self newAddSiteButtonItem] atIndex:0];
    }
    [self.navigationItem setRightBarButtonItems:barButtonItems animated:YES];
}

#pragma mark - Search / Search Delegate Methods

- (UIBarButtonItem *)newSearchBarButtonItem {

    FAKIonIcons *searchIcon = [FAKIonIcons androidSearchIconWithSize:24];
    UIImage *searchImage = [searchIcon imageWithSize:CGSizeMake(24, 24)];
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithImage:searchImage style:UIBarButtonItemStylePlain target:self action:@selector(openSearch)];
    searchButtonItem.tintColor = [UIColor whiteColor];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, topMargin, [WPView getScreenWidth], topMargin)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search Sites";
    self.searchBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.view addSubview:self.searchBar];
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    
    return searchButtonItem;
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

#pragma mark - Add Site Button / Methods

- (UIBarButtonItem *)newAddSiteButtonItem {
    FAKIonIcons *plusIcon = [FAKIonIcons androidAddIconWithSize:24];
    UIImage *plusImage = [plusIcon imageWithSize:CGSizeMake(24, 24)];
    UIBarButtonItem *addSiteButtonItem = [[UIBarButtonItem alloc] initWithImage:plusImage style:UIBarButtonItemStylePlain target:self action:@selector(showCreateSiteView)];
    addSiteButtonItem.tintColor = [UIColor whiteColor];
    return addSiteButtonItem;
}

- (void)showCreateSiteView {
    WPCreateSiteViewController *createSiteViewController = [[WPCreateSiteViewController alloc] init];
    UINavigationController *createSiteNavController = [[UINavigationController alloc] initWithRootViewController:createSiteViewController];
    [createSiteNavController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [createSiteNavController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [createSiteNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    [self.navigationController presentViewController:createSiteNavController animated:YES completion:nil];
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

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
    }
    return _refreshControl;
}



@end
