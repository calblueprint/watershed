//
//  WPTermsViewController.m
//  Watershed
//
//  Created by Melissa Huang on 11/9/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTermsViewController.h"
#import "UIExtensions.h"
#import "WPTermsView.h"

@implementation WPTermsViewController

- (void)viewDidLoad {
    self.navigationItem.title = @"Terms and Privacy";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)loadView {
    self.view = [[WPTermsView alloc] init];
}

@end
