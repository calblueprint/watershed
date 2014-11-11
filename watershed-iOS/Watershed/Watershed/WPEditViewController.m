//
//  WPEditViewController.m
//  Watershed
//
//  Created by Melissa Huang on 11/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPEditViewController.h"
#import "WPEditView.h"

@implementation WPEditViewController

- (void)viewDidLoad {
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = @"Edit Profile";
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(saveAndDismissSelf)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelf)];
    self.navigationItem.rightBarButtonItem = dismissButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor wp_lightGreen];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

-(void)loadView {
    self.view = [[WPEditView alloc] init];
}

-(void)dismissSelf {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveAndDismissSelf {
    //save
    [self dismissSelf];
}

@end
