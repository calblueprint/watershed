//
//  WPPromoteViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 5/3/15.
//  Copyright (c) 2015 Blueprint. All rights reserved.
//

#import "WPPromoteViewController.h"
#import "WPPromoteView.h"
#import "WPNetworkingManager.h"
#import "UIExtensions.h"
#import "WPUser.h"

@interface WPPromoteViewController()

@property (nonatomic) WPPromoteView *view;
@property NSMutableArray *userArray;
@property NSMutableArray *managerArray;
@property NSMutableArray *employeeArray;
@property WPUser *chosenUser;

@end
@implementation WPPromoteViewController

NSString *userIdentifier = @"WPUserCell";


- (void)loadView {
    self.view = [[WPPromoteView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Edit Users";
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userTableView.delegate = self;
    self.view.userTableView.dataSource = self;
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
        [self splitUsers];
        [strongSelf.view.userTableView reloadData];
        [self.view stopIndicator];
    }];
}


- (void)showUserActionSheet:(WPUser *)user {
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending)) {
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"" delegate:self
                                                  cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete User" otherButtonTitles:
                                @"Promote User",
                                nil];
        popup.tag = 1;
        [popup showInView:[UIApplication sharedApplication].keyWindow];
    } else {
        UIAlertController *changeUserActionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *changeUser = [[UIAlertAction alloc] init];
        if ([user.role isEqualToNumber:[NSNumber numberWithInt:1]] || [user.role isEqualToNumber:[NSNumber numberWithInt:2]]) {
            changeUser = [UIAlertAction
                                         actionWithTitle:@"Demote User"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [changeUserActionSheet dismissViewControllerAnimated:YES completion:nil];
                                             [self changeUserStatus:user];
                                         }];
        } else {
            changeUser = [UIAlertAction
                                          actionWithTitle:@"Promote User"
                                          style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action)
                                          {
                                              [changeUserActionSheet dismissViewControllerAnimated:YES completion:nil];
                                              [self changeUserStatus:user];
                                          }];
        }
        UIAlertAction *delete = [UIAlertAction
                                                 actionWithTitle:@"Delete User" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action){
                                                     [changeUserActionSheet dismissViewControllerAnimated:YES completion:nil];
                                                     [self deleteUser:user];
                                                 }];
        UIAlertAction *cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                 {
                                     [changeUserActionSheet dismissViewControllerAnimated:YES completion:nil];
                                 }];
        
        [changeUserActionSheet addAction:changeUser];
        [changeUserActionSheet addAction:delete];
        [changeUserActionSheet addAction:cancel];
        [self presentViewController:changeUserActionSheet animated:YES completion:nil];
    }
}

#pragma mark - ActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)popup
clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger buttonShift = popup.numberOfButtons - 3;
    switch (popup.tag) {
        case 1: {
            if (buttonIndex == popup.destructiveButtonIndex && buttonShift == 1) {
                [self deleteUser:self.chosenUser];
            }
            else if (buttonIndex == 0 + buttonShift) {
                if ([self.chosenUser.role isEqualToNumber:[NSNumber numberWithInt:0]]) {
                    self.chosenUser.role = [NSNumber numberWithInt:1];
                } else {
                    self.chosenUser.role = [NSNumber numberWithInt:0];
                }
                [self changeUserStatus:self.chosenUser];
            break;
            }
        }
        default:
            break;
    }
}

- (void)changeUserStatus:(WPUser *)user {
    __weak __typeof(self)weakSelf = self;
    if ([user.role isEqualToNumber:[NSNumber numberWithInt:0]]) {
        user.role = [NSNumber numberWithInt:1];
    } else {
        user.role = [NSNumber numberWithInt:0];
    }
    [[WPNetworkingManager sharedManager] editUserRoleWithUser: user
                                               parameters:[[NSMutableDictionary alloc] init]
                                                  success:^(WPUser *userResponse){
                                                      __strong __typeof(weakSelf)strongSelf = weakSelf;
                                                      [strongSelf requestAndLoadUsers];
                                                  }];
}

- (void)deleteUser:(WPUser *)user {
    NSMutableDictionary *userJSON = [[NSMutableDictionary alloc] init];
    [[WPNetworkingManager sharedManager] deleteUserWithUser:user parameters:userJSON success:^(WPUser *user) {
        [self requestAndLoadUsers];
    }];
}


#pragma mark - Table View Protocols

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier];
    WPUser *user = [[WPUser alloc] init];
    switch (indexPath.section)
    {
        case 0:
            user = [_managerArray objectAtIndex:indexPath.row];
            cell.textLabel.textColor = [UIColor wp_darkBlue];
            break;
        case 1:
            user = [_employeeArray objectAtIndex:indexPath.row];
            cell.textLabel.textColor = [UIColor wp_darkBlue];
            break;
        case 2:
            user = [_userArray objectAtIndex:indexPath.row];
            cell.textLabel.textColor = [UIColor wp_paragraph];
            break;
        default:
            break;
    }
    self.chosenUser = user;
    cell.textLabel.text = user.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

        if (indexPath.section == 0) {
            [self showUserActionSheet:self.managerArray[indexPath.row]];
        } else if (indexPath.section == 1) {
            [self showUserActionSheet:self.employeeArray[indexPath.row]];
        } else {
            [self showUserActionSheet:self.userArray[indexPath.row]];
        }
}

- (void)splitUsers {
    NSMutableArray *toBeRemoved = [[NSMutableArray alloc] init];
    _managerArray = [[NSMutableArray alloc] init];
    _employeeArray = [[NSMutableArray alloc] init];
    for (WPUser *u in _userArray) {
        if ([u.role isEqualToNumber:[NSNumber numberWithInt:2]]) {
            [_managerArray addObject:u];
            [toBeRemoved addObject:u];
        }
        else if ([u.role isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [_employeeArray addObject:u];
            [toBeRemoved addObject:u];
        }
    }
    [_userArray removeObjectsInArray:toBeRemoved];
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
