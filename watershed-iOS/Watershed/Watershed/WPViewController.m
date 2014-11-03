//
//  WPViewController.m
//  Watershed
//
//  Created by Andrew Millman on 10/29/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPViewController.h"

@interface WPViewController ()

@end

@implementation WPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *emptyBackButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:emptyBackButtonItem];
}

@end
