//
//  WPTaskViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 10/19/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTaskViewController.h"
#import "WPTaskView.h"
#import "WPAddFieldReportViewController.h"

@interface WPTaskViewController ()


@end

@implementation WPTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.dueDate.text = self.dueDate;
    self.view.taskDescription.text = self.taskDescription;
    self.view.title.text = self.taskTitle;
    self.navigationItem.title = self.taskTitle;
    [self.view.addFieldReportButton addTarget:self action:@selector(addFieldReportAction) forControlEvents:UIControlEventTouchUpInside];

}

-(void)loadView {
    self.view = [[WPTaskView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addFieldReportAction {
    WPAddFieldReportViewController *addFieldReportViewController = [[WPAddFieldReportViewController alloc] init];
    [[self navigationController] pushViewController:addFieldReportViewController animated:YES];
}
@end
