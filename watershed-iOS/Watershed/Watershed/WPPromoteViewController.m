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
    }];
}


- (void)addPhotoButtonAction {
    WPUser *u = [[WPUser alloc] init];
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending)) {
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete User" otherButtonTitles:
                                @"Promote User",
                                nil];
        popup.tag = 1;
        [popup showInView:[UIApplication sharedApplication].keyWindow];
    } else {
        UIAlertController *addPhotoActionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                                     message:nil
                                                                              preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *takePhoto = [UIAlertAction
                                    actionWithTitle:@"Promote User"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [addPhotoActionSheet dismissViewControllerAnimated:YES completion:nil];
                                        [self changeUserStatus:u];
                                    }];
        UIAlertAction *selectPhoto = [UIAlertAction
                                      actionWithTitle:@"Choose Existing"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action)
                                      {
                                          [addPhotoActionSheet dismissViewControllerAnimated:YES completion:nil];
                                          [self changeUserStatus:u];
                                          
                                      }];
        UIAlertAction *delete = [UIAlertAction
                                                 actionWithTitle:@"delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action){
                                                     [addPhotoActionSheet dismissViewControllerAnimated:YES completion:nil];
                                                     [self changeUserStatus:u];
                                                     
                                                 }];
        UIAlertAction *cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                 {
                                     [addPhotoActionSheet dismissViewControllerAnimated:YES completion:nil];
                                 }];
        
        [addPhotoActionSheet addAction:takePhoto];
        [addPhotoActionSheet addAction:selectPhoto];
        [addPhotoActionSheet addAction:cancel];
        [self presentViewController:addPhotoActionSheet animated:YES completion:nil];
    }
}

#pragma mark - ActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)popup
clickedButtonAtIndex:(NSInteger)buttonIndex {
    WPUser *u = [[WPUser alloc] init];
    NSInteger buttonShift = popup.numberOfButtons - 3;
    switch (popup.tag) {
        case 1: {
            if (buttonIndex == popup.destructiveButtonIndex && buttonShift == 1) {
            }
            else if (buttonIndex == 0 + buttonShift) {
                [self changeUserStatus:u];
            } else if (buttonIndex == 1 + buttonShift) {
                [self changeUserStatus:u];
            }
            break;
        }
        default:
            break;
    }
}

- (void)changeUserStatus:(WPUser *)user {
    NSLog(@"hi");
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
    cell.textLabel.text = user.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

        if (indexPath.section == 0) {
            
//            [self.selectAssigneeDelegate selectAssigneeViewControllerDismissed:self.managerArray[indexPath.row]];
        } else if (indexPath.section == 1) {
//            [self.selectAssigneeDelegate selectAssigneeViewControllerDismissed:self.employeeArray[indexPath.row]];
        } else {
            [self addPhotoButtonAction];
//            [self.selectAssigneeDelegate selectAssigneeViewControllerDismissed:self.userArray[indexPath.row]];
        }
//    [self.navigationController popViewControllerAnimated:YES];
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
