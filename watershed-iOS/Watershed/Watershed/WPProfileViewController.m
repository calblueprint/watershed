//
//  WPProfileViewController.m
//  Watershed
//
//  Created by Melissa Huang on 10/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPProfileViewController.h"

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
    self.view = [[WPProfileView alloc] init];
}


@end
