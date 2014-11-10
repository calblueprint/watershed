//
//  WPAddFieldReportViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 10/29/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPAddFieldReportViewController.h"
#import "WPAddFieldReportView.h"

@interface WPAddFieldReportViewController ()

@end

@implementation WPAddFieldReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)loadView {
    self.view = [[WPAddFieldReportView alloc] init];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
