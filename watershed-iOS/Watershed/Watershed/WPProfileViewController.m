//
//  WPProfileViewController.m
//  Watershed
//
//  Created by Melissa Huang on 10/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPProfileViewController.h"
#import "FontAwesomeKit/FontAwesomeKit.h"


@interface WPProfileViewController ()

@property (nonatomic) WPProfileView *view;

@end

@implementation WPProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadView
{
    self.navigationItem.title = @"My Profile";
    FAKIonIcons *settingsIcon = [FAKIonIcons ios7GearOutlineIconWithSize:20];
//    _mailIconImageView = [[UIImageView alloc] init];
//    [_mailIconImageView setImage:[mailIcon imageWithSize:CGSizeMake(15, 15)]];
    UIImage *settingsImage = [settingsIcon imageWithSize:CGSizeMake(15, 15)];
    UIBarButtonItem *settingsButtonItem = [[UIBarButtonItem alloc] initWithImage:settingsImage style:UIBarButtonItemStylePlain target:self action:@selector(openSettings)];
    self.navigationItem.rightBarButtonItem = settingsButtonItem;
    self.view = [[WPProfileView alloc] init];
}

-(void)openSettings {
    //open Settings
}


@end
