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

static NSString *CellIdentifier = @"Cell";

- (void)loadView {
    self.view = [[WPAddTaskView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"New Task";
    self.view.taskFormTableView.delegate = self;
    self.view.taskFormTableView.dataSource = self;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(saveForm:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)saveForm:(UIButton *)sender {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPAddTaskTableViewCell *cell = [[WPAddTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    switch (indexPath.row) {
        case 0: {
            UITextField *textField = [[UITextField alloc] init];
            cell = [[WPAddTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andControl:textField];
            cell.label.text = @"Task";
            break;
        }
        case 1: {
            UIDatePicker *datePicker = [[UIDatePicker alloc] init];
            cell = [[WPAddTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andControl:datePicker];
            cell.label.text = @"Due Date";
            break;
        }
        case 2: {
            UITextView *textView = [[UITextView alloc] init];
            cell = [[WPAddTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andControl:textView];
            cell.label.text = @"Description";
            break;
        }
        case 3: {
            UITextField *textField = [[UITextField alloc] init];
            cell = [[WPAddTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andControl:textField];
            cell.label.text = @"Site";
            break;
        }
        case 4: {
            UITextField *textField = [[UITextField alloc] init];
            cell = [[WPAddTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andControl:textField];
            cell.label.text = @"Assigned To";
            break;
        }
        case 5: {
            UISwitch *urgentSwitch = [[UISwitch alloc] init];
            urgentSwitch.onTintColor = [UIColor wp_red];
            cell = [[WPAddTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andControl:urgentSwitch];
            cell.label.text = @"Urgent";
            break;
        }
        default: {
            //do nothing
        }
    }
    return cell;
}


#pragma mark - Table View Protocols

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return 80;
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}



@end
