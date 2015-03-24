//
//  WPSelectAssigneeViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 11/24/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSelectAssigneeViewController.h"
#import "WPSelectAssigneeView.h"
#import "WPUser.h"
#import "WPNetworkingManager.h"

@interface WPSelectAssigneeViewController ()

@property (nonatomic) WPSelectAssigneeView *view;
@property NSMutableArray *managerArray;
@property NSMutableArray *employeeArray;
@property NSMutableArray *userArray;

@end

@implementation WPSelectAssigneeViewController

@synthesize selectAssigneeDelegate;

static NSString *CellIdentifier = @"Cell";

- (void)loadView {
    self.view = [[WPSelectAssigneeView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Select Assignee";
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.selectAssigneeTableView.delegate = self;
    self.view.selectAssigneeTableView.dataSource = self;
}

-(void)viewWillAppear:(BOOL)animated {
    [self requestAndLoadUsers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Networking Methods

- (void)requestAndLoadUsers {
    __weak __typeof(self)weakSelf = self;
    [[WPNetworkingManager sharedManager] requestUsersListWithParameters:[[NSMutableDictionary alloc] init] success:^(NSMutableArray *usersList) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.userArray = usersList;
        [strongSelf.view.selectAssigneeTableView reloadData];
        NSMutableArray *toBeRemoved = [[NSMutableArray alloc] init];
        _managerArray = [[NSMutableArray alloc] init];
        _employeeArray = [[NSMutableArray alloc] init];
//        for (WPUser *u in _userArray) {
//            NSLog(@"%@", u.role);
//            if ([u.role isEqualToNumber:[NSNumber numberWithInt:2]]) {
//                [_managerArray addObject:u];
//                [toBeRemoved addObject:u];
//            }
//            else if ([u.role isEqualToNumber:[NSNumber numberWithInt:1]]) {
//                [_employeeArray addObject:u];
//                [toBeRemoved addObject:u];
//            }
//        }
//        [_userArray removeObjectsInArray:toBeRemoved];
    }];
}

#pragma mark - Table View Protocols

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    WPUser *user = [[WPUser alloc] init];
    switch (indexPath.section)
    {
        case 0:
            user = [_managerArray objectAtIndex:indexPath.row];
            break;
        case 1:
            user = [_employeeArray objectAtIndex:indexPath.row];
            break;
        case 2:
            user = [_userArray objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    cell.textLabel.text = user.name;
    cell.textLabel.textColor = [UIColor wp_paragraph];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.selectAssigneeDelegate respondsToSelector:@selector(selectAssigneeViewControllerDismissed:)]) {
        [self.selectAssigneeDelegate selectAssigneeViewControllerDismissed:self.userArray[indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table View Protocols

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section)
    {
        case 0:
            return [_managerArray count];
        case 1:
            return [_employeeArray count];
        case 2:
            return [_userArray count];
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section)
    {
        case 0:
            return @"Managers";
        case 1:
            return @"Employees";
        case 2:
            return @"Community Members";
        default:
            return @"";
    }
}

@end
