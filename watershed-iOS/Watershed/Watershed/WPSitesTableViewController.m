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

@end

@implementation WPSitesTableViewController

- (void)loadView {
    self.view = [[WPSitesTableView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ((WPSitesTableView *)self.view).delegate = self;
    ((WPSitesTableView *)self.view).dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cellView = nil;
    
    if ([tableView isEqual:self.view]) {
        
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

@end
