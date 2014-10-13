//
//  WPSiteViewController.m
//  Watershed
//
//  Created by Andrew on 10/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSiteViewController.h"
#import "WPSiteView.h"
#import "WPMiniSiteTableViewCell.h"

@interface WPSiteViewController ()

@property (nonatomic) UITableView *miniSiteTableView;
@property (nonatomic) NSMutableArray *miniSiteList;

@end

@implementation WPSiteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadMiniSiteData];
    self.miniSiteTableView.delegate = self;
    self.miniSiteTableView.dataSource = self;
}

- (void)loadView
{
    self.view = [[WPSiteView alloc] init];
    self.miniSiteTableView = ((WPSiteView *)self.view).miniSiteTableView;
}

- (void)loadMiniSiteData
{
    NSLog(@"Fetching mini site data");
    
    self.miniSiteList = @[@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1"];
}

#pragma mark - TableView Delegate/DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Call number of rows");
    NSInteger rowCount = 0;
    
    if ([tableView isEqual:self.miniSiteTableView]) rowCount = self.miniSiteList.count;
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Render cell at given index path");
    
    UITableViewCell *cellView = nil;
    
    if ([tableView isEqual:self.miniSiteTableView]) {
        static NSString *cellIdentifier = @"MiniSiteCell";
        cellView = [[WPMiniSiteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:cellIdentifier
                                                             name:@"Yes"
                                                            image:[UIImage new]
                                                           rating:5
                                                        taskCount:5
                                                 fieldReportCount:5];
    }
    return cellView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

@end
