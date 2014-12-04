//
//  WPProfileViewController.m
//  Watershed
//
//  Created by Melissa Huang on 10/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPProfileViewController.h"
#import "WPSettingsTableViewController.h"
#import "WPUser.h"
#import "WPNetworkingManager.h"

@interface WPProfileViewController ()

@property (nonatomic) WPProfileView *view;
@property (nonatomic) WPUser *user;

@end

@implementation WPProfileViewController

- (void)viewDidLoad {
    self.navigationItem.title = @"My Profile";
    FAKIonIcons *settingsIcon = [FAKIonIcons ios7GearOutlineIconWithSize:22];
    UIImage *settingsImage = [settingsIcon imageWithSize:CGSizeMake(22, 22)];
    UIBarButtonItem *settingsButtonItem = [[UIBarButtonItem alloc] initWithImage:settingsImage style:UIBarButtonItemStylePlain target:self action:@selector(openSettings)];
    settingsButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = settingsButtonItem;
    _user = [[WPUser alloc] init];
    _user.userId = [[WPNetworkingManager sharedManager] keyChainStore][@"userId"];
    [[WPNetworkingManager sharedManager] requestUserWithUser:_user parameters:[[NSMutableDictionary alloc] init] success:^(WPUser *user) {
        _user = user;
        [self.view configureWithUser:user];
    }];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)loadView {
    self.view = [[WPProfileView alloc] init];
}

-(void)openSettings {
    WPSettingsTableViewController *settingsTableViewController = [[WPSettingsTableViewController alloc] init];
    settingsTableViewController.user = self.user;
    [self.navigationController pushViewController:settingsTableViewController animated:YES];
}


@end
