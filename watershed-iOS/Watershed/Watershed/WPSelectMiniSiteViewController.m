//
//  WPSelectMiniSiteViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 11/24/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSelectMiniSiteViewController.h"
#import "WPSelectMiniSiteView.h"
#import "WPSite.h"
#import "WPNetworkingManager.h"

@interface WPSelectMiniSiteViewController ()

@property (nonatomic) WPSelectMiniSiteView *view;
@property NSMutableArray *miniSiteArray;

@end

@implementation WPSelectMiniSiteViewController

@synthesize selectSiteDelegate;

static NSString *CellIdentifier = @"Cell";

- (void)loadView {
    self.view = [[WPSelectMiniSiteView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Select Mini Site";
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.selectMiniSiteTableView.delegate = self;
    self.view.selectMiniSiteTableView.dataSource = self;
    
    [self requestAndLoadSites];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cellView = nil;
    
    if ([tableView isEqual:self.view.selectMiniSiteTableView]) {
        
        cellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if (!cellView) {
            cellView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:CellIdentifier];
        }
        WPMiniSite *site = self.miniSiteArray[indexPath.row];
        cellView.textLabel.text = site.name;
        cellView.textLabel.textColor = [UIColor wp_paragraph];
    }
    return cellView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.selectSiteDelegate respondsToSelector:@selector(selectSiteViewControllerDismissed:)]) {
        [self.selectSiteDelegate selectSiteViewControllerDismissed:self.miniSiteArray[indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Networking Methods

- (void)requestAndLoadSites {
    self.miniSiteArray = [[NSMutableArray alloc] init];

    __weak __typeof(self)weakSelf = self;
    [[WPNetworkingManager sharedManager] requestMiniSitesListWithParameters:[[NSMutableDictionary alloc] init] success:^(NSMutableArray *sitesList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.miniSiteArray addObjectsFromArray:sitesList];
        [strongSelf.view.selectMiniSiteTableView reloadData];
    }];
}

#pragma mark - Table View Protocols

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_miniSiteArray count];
}


@end
