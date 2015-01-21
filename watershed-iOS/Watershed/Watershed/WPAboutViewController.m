//
//  WPAboutViewController.m
//  Watershed
//
//  Created by Melissa Huang on 11/9/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPAboutViewController.h"
#import "WPAboutView.h"

@implementation WPAboutViewController

- (void)viewDidLoad {
    self.navigationItem.title = @"Watershed";
}

- (void)loadView {
    self.view = [[WPAboutView alloc] init];
}


@end