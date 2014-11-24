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

@property NSArray *taskArray;

@end

@implementation WPSelectTaskViewController

static NSString *CellIdentifier = @"Cell";

- (void)loadView {
    self.view[[WPSelectTaskView] NSString
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _taskArray = @[@"Water Tree", @"Kill Tree", @"Plant Tree", @"Feed Tree"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.textLabel.text = [_taskArray objectAtIndex:indexPath.row];
    if (indexPath.row == [_taskArray count]) {
        UITextField *customTask = [[UITextField alloc] init];
        [cell.contentView addSubview:customTask];
    }
    return cell;
}

#pragma mark - Table View Protocols

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_taskArray count];
}


@end
