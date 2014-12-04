//
//  WPCreateSiteViewController.m
//  Watershed
//
//  Created by Andrew Millman on 12/2/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPCreateSiteViewController.h"
#import "WPCreateSiteView.h"

@interface WPCreateSiteViewController ()

@end

@implementation WPCreateSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = @"New Site";
    
    FAKFontAwesome *closeIcon = [FAKFontAwesome closeIconWithSize:22];
    UIImage *closeImage = [closeIcon imageWithSize:CGSizeMake(22, 22)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:closeImage style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor wp_red];
    
    FAKFontAwesome *checkIcon = [FAKFontAwesome checkIconWithSize:22];
    UIImage *checkImage = [checkIcon imageWithSize:CGSizeMake(22, 22)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithImage:checkImage style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = doneButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor wp_lightGreen];
}

- (void)loadView {
    self.view = [[WPCreateSiteView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
