//
//  WPSettingsTableViewController.m
//  Watershed
//
//  Created by Melissa Huang on 10/29/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSettingsTableViewController.h"
#import "WPSettingsTableViewCell.h"
#import "WPSettingsTableView.h"

@interface WPSettingsTableViewController ()

@property (nonatomic) UITableView *settingsTableView;


@end

@implementation WPSettingsTableViewController

NSString *settingsReuseIdentifier = @"WPSettingsCell";

- (void)loadView {
    self.view = [[WPView alloc] initWithFrame:[[UIScreen mainScreen] bounds] visibleNavbar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Settings";
    _settingsTableView = [[WPSettingsTableView alloc] init];
    [self.view addSubview:_settingsTableView];
    
    _settingsTableView.delegate = self;
    _settingsTableView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPSettingsTableViewCell *cell = [[WPSettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:settingsReuseIdentifier];
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = @"Edit Profile";
            break;
        }
        case 1: {
            break;
        }
        case 2: {
            break;
        }
        default: {
            //do nothing
        }
    }
    return cell;
}


@end
