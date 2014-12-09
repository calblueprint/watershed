//
//  WPSelectAssigneeViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 11/24/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSelectAssigneeViewController.h"
#import "WPSelectAssigneeView.h"

@interface WPSelectAssigneeViewController ()

@property (nonatomic) WPSelectAssigneeView *view;
@property NSArray *employeeArray;
@property NSArray *communityArray;

@end

@implementation WPSelectAssigneeViewController

@synthesize selectAssigneeDelegate;

static NSString *CellIdentifier = @"Cell";

- (void)loadView {
    self.view = [[WPSelectAssigneeView alloc] init];
}

- (void)viewDidLoad {
    self.navigationItem.title = @"Select Assignee";
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.selectAssigneeTableView.delegate = self;
    self.view.selectAssigneeTableView.dataSource = self;
    _employeeArray = @[@"Mark", @"Max", @"Melissa", @"Andrew"];
    _communityArray = @[@"Community 1", @"Community 2", @"Community 3",  @"Community 4",  @"Community 5",  @"Community 6",  @"Community 7"];
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if(indexPath.section == 0) {
        cell.textLabel.text = [_employeeArray objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [_communityArray objectAtIndex:indexPath.row];
    }
    cell.textLabel.textColor = [UIColor wp_paragraph];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.selectAssigneeDelegate respondsToSelector:@selector(selectAssigneeViewControllerDismissed:)]) {
        [self.selectAssigneeDelegate selectAssigneeViewControllerDismissed:[self.view.selectAssigneeTableView cellForRowAtIndexPath:indexPath].textLabel.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table View Protocols

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [_employeeArray count];
    } else {
        return [_communityArray count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"Employees";
    } else {
        return @"Community Members";
    }
}

@end
