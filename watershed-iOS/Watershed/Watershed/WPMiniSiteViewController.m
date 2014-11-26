//
//  WPMiniSiteViewController.m
//  Watershed
//
//  Created by Andrew Millman on 11/2/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPMiniSiteViewController.h"
#import "WPMiniSiteView.h"
#import "WPFieldReportTableViewCell.h"
#import "WPFieldReportViewController.h"
#import "WPNetworkingManager.h"

@interface WPMiniSiteViewController ()

@property (nonatomic) WPMiniSiteView *view;
@property (nonatomic) UITableView *fieldReportTableView;
@property (nonatomic) NSMutableArray *fieldReportList;

@end

static NSString *cellIdentifier = @"FieldReportCell";

@implementation WPMiniSiteViewController
@synthesize miniSite = _miniSite;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.miniSite.name;
    self.fieldReportTableView.delegate = self;
    self.fieldReportTableView.dataSource = self;
    
    [[WPNetworkingManager sharedManager] requestMiniSiteWithMiniSite:self.miniSite parameters:[[NSMutableDictionary alloc] init] success:^(WPMiniSite *miniSite, NSMutableArray *fieldReportList) {
    }];
}

- (void)loadView {
    self.view = [[WPMiniSiteView alloc] init];
    self.fieldReportTableView = self.view.fieldReportTableView;
}

- (void)loadFieldReportData {
    self.fieldReportList = @[@1, @3, @4, @2, @5, @1, @5, @2, @2, @3, @4, @0].mutableCopy;
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
    
    if ([tableView isEqual:self.fieldReportTableView]) rowCount = self.fieldReportList.count;
    [(WPMiniSiteView *)self.view updateTableViewHeight:self.fieldReportList.count];
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cellView = nil;
    
    if ([tableView isEqual:self.fieldReportTableView]) {
        
        cellView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cellView) {
            cellView = [[WPFieldReportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:cellIdentifier];
        }
    }
    return cellView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WPFieldReportTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPFieldReportViewController *fieldReportController = [[WPFieldReportViewController alloc] init];
    [self.navigationController pushViewController:fieldReportController animated:YES];
}

- (void)updateMiniSiteView {
    self.view.originalCoverPhoto = self.miniSite.image;
    self.view.coverPhotoView.image = self.view.originalCoverPhoto;
    self.view.titleLabel.text = self.miniSite.name;
    self.view.descriptionLabel.text = self.miniSite.info;
    self.view.addressLabel.label.text = [NSString stringWithFormat:@"%@, %@, %@ %@", self.miniSite.street, self.miniSite.city, self.miniSite.state, self.miniSite.zipCode];
    self.view.vegetationListLabel.text = self.miniSite.vegetations;
    self.view.currentTaskLabel.text = self.miniSite.currentTask;
    self.view.fieldReportCountLabel.label.text = [[self.miniSite.fieldReportCount stringValue] stringByAppendingString:@" field reports"];
}

#pragma mark - Setter Methods

- (void)setMiniSite:(WPMiniSite *)miniSite {
    _miniSite = miniSite;
    [self updateMiniSiteView];
}

#pragma mark - Lazy Instantiation

- (NSMutableArray *)miniSiteList {
    if (!_fieldReportList) {
        _fieldReportList = [[NSMutableArray alloc] init];
    }
    return _fieldReportList;
}

- (WPMiniSite *)miniSite {
    if (!_miniSite) {
        _miniSite = [[WPMiniSite alloc] init];
    }
    return _miniSite;
}

@end
