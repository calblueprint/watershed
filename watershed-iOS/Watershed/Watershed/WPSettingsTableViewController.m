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
#import "WPTermsViewController.h"
#import "WPRootViewController.h"
#import "WPNetworkingManager.h"
#import "WPAppDelegate.h"

@interface WPSettingsTableViewController ()

@property (nonatomic) UITableView *settingsTableView;
@property (nonatomic) WPEditViewController *editViewController;

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
                [switchView addTarget:self action:@selector(togglePush:) forControlEvents:UIControlEventValueChanged];
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
    if (indexPath.section == 0 && indexPath.row == 0) { // Edit Profile
        _editViewController = [[WPEditViewController alloc] initWithUser:_user];
        UINavigationController *editNavController = [[UINavigationController alloc] initWithRootViewController:_editViewController];
        [editNavController.navigationBar setBackgroundColor:[UIColor whiteColor]];
        [editNavController.navigationBar setBarTintColor:[UIColor whiteColor]];
        [editNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        [self.navigationController presentViewController:editNavController animated:YES completion:nil];
    } else if (indexPath.section == 1) { // About
        if (indexPath.row == 0) {
            WPAboutViewController *aboutViewController = [[WPAboutViewController alloc] init];
            [self.navigationController pushViewController:aboutViewController animated:YES];
        } else if (indexPath.row == 1) {
            WPTermsViewController *termsViewController = [[WPTermsViewController alloc] init];
            [self.navigationController pushViewController:termsViewController animated:YES];
        }
    } else if (indexPath.section == 2) { // Log out
        if (indexPath.row == 0) {
            [self logoutPrompt];
        }
    }
}

#pragma mark - Log out prompt

- (void)logoutPrompt {
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending)) {
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to log out?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Log Out"
                                                  otherButtonTitles:nil];
        popup.tag = 1;
        [popup showInView:[UIApplication sharedApplication].keyWindow];
    } else {
        UIAlertController *addPhotoActionSheet =
        [UIAlertController alertControllerWithTitle:@"Are you sure you want to log out?"
                                            message:nil
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *logout =
        [UIAlertAction actionWithTitle:@"Log Out"
                                 style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction * action) {
                                   [addPhotoActionSheet dismissViewControllerAnimated:YES completion:nil];
                                   [self logout];
                                    }];
        UIAlertAction *cancel =
        [UIAlertAction actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   [addPhotoActionSheet dismissViewControllerAnimated:YES completion:nil];
                                   }];
        
        [addPhotoActionSheet addAction:logout];
        [addPhotoActionSheet addAction:cancel];
        [self presentViewController:addPhotoActionSheet animated:YES completion:nil];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            [self logout];
        }
    }
}


- (void)logout {
    [[WPNetworkingManager sharedManager] eraseLoginKeyChainInfo];
    //DELETE user session
    [FBSession.activeSession closeAndClearTokenInformation];
    WPRootViewController *parentVC = (WPRootViewController *)self.parentViewController.parentViewController.parentViewController;
    [parentVC pushNewLoginControllerFromTab:(WPTabBarController *)self.parentViewController.parentViewController];
}

#pragma mark - UISwitch Delegate

- (void)togglePush:(id)sender {
    [[WPAppDelegate instance] setShouldSendPush:[sender isOn]];
}


@end
