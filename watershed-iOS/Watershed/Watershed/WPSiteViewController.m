//
//  WPSiteViewController.m
//  Watershed
//
//  Created by Andrew on 10/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSiteViewController.h"
#import "WPSiteView.h"

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
}

@end
