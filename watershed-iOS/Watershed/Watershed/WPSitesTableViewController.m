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
@property (nonatomic) UISearchDisplayController *searchController;
@property (nonatomic) UISearchBar *searchBar;

@end

static NSString *cellIdentifier = @"SiteCell";

@implementation WPSitesTableViewController

- (void)loadView {
    self.view = [[WPView alloc] initWithFrame:[[UIScreen mainScreen] bounds] visibleNavbar:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"Sites";
    
    NSMutableArray *barButtonItems = [[NSMutableArray alloc] initWithObjects:[self newSearchBarButtonItem], nil];
    NSString *userRole = [WPNetworkingManager sharedManager].keyChainStore[@"role"];
    if ([userRole isEqual:@"0"]) {
        [barButtonItems addObject:[self newAddSiteButtonItem]];
    }
    [self.navigationItem setRightBarButtonItems:barButtonItems animated:YES];
    
    self.sitesTableView.delegate = self;
    self.sitesTableView.dataSource = self;
    
    __weak __typeof(self)weakSelf = self;
    [[WPNetworkingManager sharedManager] requestSitesListWithParameters:[[NSMutableDictionary alloc] init] success:^(NSMutableArray *sitesList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.sitesList = sitesList;
        [strongSelf.sitesTableView reloadData];
    }];
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
        [cellView.photoView setImageWithURL:[site.imageURLs firstObject]
                           placeholderImage:[UIImage imageNamed:@"SampleCoverPhoto"]];
        cellView.miniSiteLabel.text = [[site.miniSitesCount stringValue] stringByAppendingString:@" mini sites"];
        
        [self updatePhotoOffset:self.sitesTableView.contentOffset.y];
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

- (UIBarButtonItem *)newSearchBarButtonItem {

    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                         target:self
                                         action:@selector(openSearch) ];
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

#pragma mark - Add Site Button

- (UIBarButtonItem *)newAddSiteButtonItem {
    UIBarButtonItem *addSiteButtonItem = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                         target:self
                                         action:nil ];
    addSiteButtonItem.tintColor = [UIColor whiteColor];
    
    return addSiteButtonItem;
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
