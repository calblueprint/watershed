//
//  LoginViewController.m
//  Watershed
//
//  Created by Andrew Millman on 9/28/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPLoginViewController.h"
#import "WPLoginView.h"

@interface WPLoginViewController ()

@end

@implementation WPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)loadView {
    self.view = [[WPLoginView alloc] init];
}


@end
