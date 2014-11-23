//
//  WPAddTaskViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 11/21/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPAddTaskViewController.h"
#import "WPAddTaskView.h"
#import "WPAddTaskTableViewCell.h"

@interface WPAddTaskViewController()

@property (nonatomic) WPAddTaskView *view;
@end

@implementation WPAddTaskViewController

- (void)loadView {
    self.view = [[WPAddTaskView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.taskFormTableView.delegate = self;
    self.view.taskFormTableView.dataSource = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)saveForm:(UIButton *)sender {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPAddTaskTableViewCell *cell = [[WPAddTaskTableViewCell alloc] init];
//    switch (indexPath.row) {
//        case 1: {
//            FAKIonIcons *mailIcon = [FAKIonIcons ios7EmailOutlineIconWithSize:30];
//            [cell setIconImageView:[[UIImageView alloc] initWithImage:[mailIcon imageWithSize:CGSizeMake(30, 30)]]];
//            
//            UILabel *infoLabel = [[UILabel alloc] init];
//            infoLabel.text = self.user.email;
//            [cell setInfoLabel:infoLabel];
//            
//            break;
//        }
//        case 2: {
//            FAKIonIcons *locationIcon = [FAKIonIcons ios7LocationOutlineIconWithSize:30];
//            [cell setIconImageView:[[UIImageView alloc] initWithImage:[locationIcon imageWithSize:CGSizeMake(30, 30)]]];
//            
//            UILabel *infoLabel = [[UILabel alloc] init];
//            infoLabel.text = self.user.location;
//            [cell setInfoLabel:infoLabel];
//            break;
//        }
//        case 3: {
//            FAKIonIcons *phoneIcon = [FAKIonIcons ios7TelephoneOutlineIconWithSize:30];
//            [cell setIconImageView:[[UIImageView alloc] initWithImage:[phoneIcon imageWithSize:CGSizeMake(30, 30)]]];
//            
//            UILabel *infoLabel = [[UILabel alloc] init];
//            infoLabel.text = self.user.phoneNumber;
//            [cell setInfoLabel:infoLabel];
//            break;
//        }
//        default: {
//            //do nothing
//        }
//    }
//    cell.infoLabel.textColor = [UIColor darkGrayColor];
//    cell.infoLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
//    [cell addSubviews];
    return cell;
}


#pragma mark - Table View Protocols

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 1.f;
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}



@end
