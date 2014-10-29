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

@interface WPSitesTableViewController ()

@property (nonatomic) WPSitesTableView *sitesTableView;
@property (nonatomic) NSMutableArray *siteList;

@end

@implementation WPSitesTableViewController

- (void)loadView {
    self.view = [[WPView alloc] initWithFrame:[[UIScreen mainScreen] bounds] visibleNavbar:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"Sites";
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
    NSLog(@"Call number of rows");
    NSInteger rowCount = 0;
    
    if ([tableView isEqual:self.sitesTableView]) rowCount = self.siteList.count;
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cellView = nil;
    
    if ([tableView isEqual:self.sitesTableView]) {
        
        static NSString *cellIdentifier = @"SiteCell";
        cellView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cellView) {
            
            NSLog(@"RENDER NEW");
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

#pragma mark - Lazy instantiation

- (WPSitesTableView *)sitesTableView {
    if (!_sitesTableView) {
        _sitesTableView = [[WPSitesTableView alloc] init];
        [self.view addSubview:_sitesTableView];
    }
    return _sitesTableView;
}



@end
