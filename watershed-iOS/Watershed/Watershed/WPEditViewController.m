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
    self.title = @"Edit Profile";
}

-(void)loadView {
    self.view = [[WPEditView alloc] init];
}

@end
