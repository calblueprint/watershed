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

@interface WPSitesTableViewController () <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic) WPSitesTableView *sitesTableView;
@property (nonatomic) NSMutableArray *siteList;
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
    
    [self setUpSearchBar];
    
    [self loadSiteData];
    self.sitesTableView.delegate = self;
    self.sitesTableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updatePhotoOffset:self.sitesTableView.contentOffset.y];
}

- (void)loadSiteData {
    self.siteList = @[@1, @3, @4, @2, @5, @1, @5, @2, @2, @3, @4, @0].mutableCopy;
}

#pragma mark - TableView Delegate/DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

    NSInteger rowCount = 0;
    
    if ([tableView isEqual:self.sitesTableView]) rowCount = self.siteList.count;
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cellView = nil;
    
    if ([tableView isEqual:self.sitesTableView]) {
        
        cellView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cellView) {
            
            cellView = [[WPSiteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:cellIdentifier
                                                                 name:@"Sample Site"
                                                                image:[UIImage imageNamed:@"SampleCoverPhoto"]
                                                        miniSiteCount:[self.siteList[indexPath.row] intValue]
                        ];
        }
    }
    return cellView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WPSiteTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    FAKFontAwesome *searchIcon = [FAKFontAwesome searchIconWithSize:18];
    UIImage *searchImage = [searchIcon imageWithSize:CGSizeMake(20, 20)];
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithImage:searchImage style:UIBarButtonItemStylePlain target:self action:@selector(openSearch)];
    searchButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = searchButtonItem;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, topMargin, [[UIScreen mainScreen] bounds].size.width, topMargin)];
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
        [self.searchBar setFrame:CGRectMake(0, 10, [[UIScreen mainScreen] bounds].size.width, topMargin)];
    }];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    [self searchBarCancelButtonClicked:self.searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.2 animations:^{
        [self.searchBar setFrame:CGRectMake(0, topMargin, [[UIScreen mainScreen] bounds].size.width, topMargin)];
    }];
}

#pragma mark - Lazy instantiation

- (WPSitesTableView *)sitesTableView {
    if (!_sitesTableView) {
        _sitesTableView = [[WPSitesTableView alloc] init];
        [self.view addSubview:_sitesTableView];
    }
    return _sitesTableView;
}



@end
