//
//  WPSelectTaskViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 11/23/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSelectTaskViewController.h"
#import "WPSelectTaskView.h"

@interface WPSelectTaskViewController ()

@property (nonatomic) WPSelectTaskView *view;
@property NSArray *taskArray;


@end

@implementation WPSelectTaskViewController

@synthesize selectTaskDelegate;

static NSString *CellIdentifier = @"Cell";

- (void)loadView {
    self.view = [[WPSelectTaskView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.selectTaskTableView.delegate = self;
    self.view.selectTaskTableView.dataSource = self;
    _taskArray = @[@"Water Tree", @"Kill Tree", @"Plant Tree", @"Feed Tree"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.textLabel.text = [_taskArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor wp_paragraph];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.selectTaskDelegate respondsToSelector:@selector(selectTaskViewControllerDismissed:)]) {
        [self.selectTaskDelegate selectTaskViewControllerDismissed:[self.view.selectTaskTableView cellForRowAtIndexPath:indexPath].textLabel.text];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View Protocols

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_taskArray count];
}


@end
