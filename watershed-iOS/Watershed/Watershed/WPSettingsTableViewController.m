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
#import "WPEditViewController.h"
#import "WPAboutViewController.h"

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
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0: {
            return 2;
        }
        case 1: {
            return 2;
        }
        case 2: {
            return 1;
        }
        default: {
            //do nothing;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:settingsReuseIdentifier];
    if (!cell) {
        cell = [[WPSettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:settingsReuseIdentifier];
    }
    
    switch (indexPath.row) {
        case 0: {
            if (indexPath.section == 0) {
                cell.textLabel.text = @"Edit Profile";
            } else if (indexPath.section == 1) {
                cell.textLabel.text = @"About The Watershed Project";
            } else if (indexPath.section == 2) {
                cell.textLabel.text = @"Log Out";
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
            }
            break;
        }
        case 1: {
            if (indexPath.section == 0) {
                cell.textLabel.text = @"Push Notifications";
                UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
                cell.accessoryView = switchView;
            } else if (indexPath.section == 1) {
                cell.textLabel.text = @"Terms and Privacy";
            }
            break;
        }
        default: {
            //do nothing
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0 && indexPath.row == 0) {
        WPEditViewController *editViewController = [[WPEditViewController alloc] init];
        UINavigationController *editNavController = [[UINavigationController alloc] initWithRootViewController:editViewController];
        [editNavController.navigationBar setBackgroundColor:[UIColor whiteColor]];
        [editNavController.navigationBar setBarTintColor:[UIColor whiteColor]];
        [editNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        [self.navigationController presentViewController:editNavController animated:YES completion:nil];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        WPAboutViewController *aboutViewController = [[WPAboutViewController alloc] init];
        [self.navigationController pushViewController:aboutViewController animated:YES];
    }
}


@end
