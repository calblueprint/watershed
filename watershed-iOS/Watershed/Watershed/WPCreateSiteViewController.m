//
//  WPCreateSiteViewController.m
//  Watershed
//
//  Created by Andrew Millman on 12/2/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPCreateSiteViewController.h"
#import "WPCreateSiteView.h"
#import "WPCreateSiteTableViewCell.h"

@interface WPCreateSiteViewController ()
@property (nonatomic) WPCreateSiteView *view;
@property (nonatomic) UITableView *infoTableView;
@end

@implementation WPCreateSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = @"New Site";
    
    FAKFontAwesome *closeIcon = [FAKFontAwesome closeIconWithSize:22];
    UIImage *closeImage = [closeIcon imageWithSize:CGSizeMake(22, 22)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:closeImage style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor wp_blue];
    
    FAKFontAwesome *checkIcon = [FAKFontAwesome checkIconWithSize:22];
    UIImage *checkImage = [checkIcon imageWithSize:CGSizeMake(22, 22)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithImage:checkImage style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = doneButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor wp_blue];
}

- (void)loadView {
    self.view = [[WPCreateSiteView alloc] init];
    self.infoTableView = self.view.infoTableView;
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
}

#pragma mark - Table View Delegate / Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0: {
            return 1;
            break;
        }
        case 1: {
            return 4;
            break;
        }
        case 2: {
            return 1;
            break;
        }
        default: {
            return 1;
            break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return 120;
    }
    else {
        return 44;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPCreateSiteTableViewCell *cell = [[WPCreateSiteTableViewCell alloc] init];
    
    switch (indexPath.section) {
        // Name
        case 0: {
            cell.textInput = [[UITextField alloc] init];
            cell.inputLabel.text = @"Name";
            break;
        }
        // Address
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    cell.textInput = [[UITextField alloc] init];
                    cell.inputLabel.text = @"Street";
                    break;
                }
                case 1: {
                    cell.textInput = [[UITextField alloc] init];
                    cell.inputLabel.text = @"City";
                    break;
                }
                case 2: {
                    cell.textInput = [[UITextField alloc] init];
                    cell.inputLabel.text = @"State";
                    break;
                }
                case 3: {
                    cell.textInput = [[UITextField alloc] init];
                    cell.inputLabel.text = @"Zip Code";
                    break;
                }
                default: {
                    //do nothing
                }
            }
            break;
        }
        // Description
        case 2: {
            UITextView *descriptionView = [[UITextView alloc] init];
            descriptionView.font = [UIFont systemFontOfSize:17.0];
            cell.textInput = descriptionView;
            cell.inputLabel.text = @"Description";
            break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


@end
