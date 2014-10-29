//
//  WPSitesTableViewController.m
//  Watershed
//
//  Created by Melissa Huang on 10/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSitesTableViewController.h"
#import "WPSitesTableView.h"
#import "WPSiteTableViewCell.h"

@interface WPSitesTableViewController ()

@property (nonatomic) WPSitesTableView *sitesTableView;

@end

@implementation WPSitesTableViewController

- (void)loadView {
    self.view = [[WPView alloc] initWithFrame:[[UIScreen mainScreen] bounds] visibleNavbar:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"Sites";
    self.sitesTableView.delegate = self;
    self.sitesTableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updatePhotoOffset:self.sitesTableView.contentOffset.y];
}

#pragma mark - TableView Delegate/DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 10;
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
                                                        miniSiteCount:5
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
