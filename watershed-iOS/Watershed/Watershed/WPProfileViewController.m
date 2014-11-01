//
//  WPProfileViewController.m
//  Watershed
//
//  Created by Melissa Huang on 10/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPProfileViewController.h"
#import "WPSettingsTableViewController.h"



@interface WPProfileViewController ()

@property (nonatomic) WPProfileView *view;

@end

@implementation WPProfileViewController

- (void)viewDidLoad {
    self.navigationItem.title = @"My Profile";
    FAKIonIcons *settingsIcon = [FAKIonIcons ios7GearOutlineIconWithSize:20];
    UIImage *settingsImage = [settingsIcon imageWithSize:CGSizeMake(20, 20)];
    UIBarButtonItem *settingsButtonItem = [[UIBarButtonItem alloc] initWithImage:settingsImage style:UIBarButtonItemStylePlain target:self action:@selector(openSettings)];
    settingsButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = settingsButtonItem;
    self.editButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
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
    [self.navigationController pushViewController:settingsTableViewController animated:NO];
}


@end
