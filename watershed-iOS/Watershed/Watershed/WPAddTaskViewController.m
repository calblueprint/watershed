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
#import "UIExtensions.h"
#import "WPSelectTaskViewController.h"
#import "WPSelectMiniSiteViewController.h"


@interface WPAddTaskViewController()

@property (nonatomic) WPAddTaskView *view;
@property (nonatomic) UITextField *dateField;
@property (nonatomic) UITextField *taskField;
@property (nonatomic) UITextField *siteField;


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
    self.view.taskFormTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.view.taskFormTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)saveForm:(UIButton *)sender {
    
}

- (void)selectTaskViewControllerDismissed:(NSString *)stringForFirst
{
    _taskField.text = stringForFirst;
}

- (void)secondViewControllerDismissed:(NSString *)stringForFirst
{
    _siteField.text = stringForFirst;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 1) {
        WPSelectTaskViewController *selectTaskViewController = [[WPSelectTaskViewController alloc] init];
        selectTaskViewController.myString = @"This text is passed from firstViewController!";
        selectTaskViewController.selectTaskDelegate = self;
        selectTaskViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:selectTaskViewController animated:YES completion:nil];
    }
    if (textField.tag == 2) {
        WPSelectMiniSiteViewController *selectMiniSiteViewController = [[WPSelectMiniSiteViewController alloc] init];
        selectMiniSiteViewController.myString = @"This text is passed from firstViewController!";
        selectMiniSiteViewController.selectTaskDelegate = self;
        selectMiniSiteViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:selectMiniSiteViewController animated:YES completion:nil];
    }
    return YES;
}

- (void)selectTask {
    WPSelectTaskViewController *selectTaskViewController = [[WPSelectTaskViewController alloc] init];
    selectTaskViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:selectTaskViewController animated:YES completion:nil];
}

- (void)datePickerValueChanged:(id)sender{
    UIDatePicker *picker = (UIDatePicker *)sender;
    NSString *dateString;
    dateString = [NSDateFormatter localizedStringFromDate:[picker date]
                                                dateStyle:NSDateFormatterMediumStyle
                                                timeStyle:NSDateFormatterNoStyle];
    [_dateField setText:dateString];
}

- (WPAddTaskTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPAddTaskTableViewCell *cell = [[WPAddTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    switch (indexPath.row) {
        case 0: {
            _taskField = [[UITextField alloc] init];
            _taskField.delegate = self;
            _taskField.placeholder = @"Task";
            _taskField.tag = 1;
            _taskField.textColor = [UIColor wp_paragraph];
            _taskField.font = [UIFont systemFontOfSize:16];
            cell = [[WPAddTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andControl:_taskField];
            cell.label.text = @"Task";
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTask)];
            [_taskField addGestureRecognizer:tapRecognizer];
            break;
        }
        case 1: {
            _dateField = [[UITextField alloc] init];
            _dateField.delegate = self;
            cell = [[WPAddTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andControl:_dateField];
            UIDatePicker *datePicker = [[UIDatePicker alloc] init];
            datePicker.datePickerMode = UIDatePickerModeDate;
            [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
            datePicker.tag = indexPath.row;
            _dateField.inputView = datePicker;
            _dateField.placeholder = @"Due Date";
            cell.label.text = @"Due Date";
            _dateField.textColor = [UIColor wp_paragraph];
            _dateField.font = [UIFont systemFontOfSize:16];
            break;
        }
        case 2: {
            UISwitch *urgentSwitch = [[UISwitch alloc] init];
            urgentSwitch.onTintColor = [UIColor wp_red];
            cell = [[WPAddTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andControl:urgentSwitch];
            cell.label.text = @"Urgent";
            break;
        }
        case 3: {
            _siteField = [[UITextField alloc] init];
            _siteField.delegate = self;
            cell = [[WPAddTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andControl:_siteField];
            _siteField.placeholder = @"Site";
            cell.label.text = @"Site";
            _siteField.tag = 2;
            _siteField.textColor = [UIColor wp_paragraph];
            _siteField.font = [UIFont systemFontOfSize:16];
            break;
        }
        case 4: {
            UITextField *textField = [[UITextField alloc] init];
            textField.delegate = self;
            cell = [[WPAddTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andControl:textField];
            textField.placeholder = @"Assignee";
            cell.label.text = @"Assignee";
            textField.textColor = [UIColor wp_paragraph];
            textField.font = [UIFont systemFontOfSize:16];
            break;
        }
        case 5: {
            UITextView *textView = [[UITextView alloc] init];
            cell = [[WPAddTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andControl:textView];
            cell.label.text = @"Description";
            textView.textColor = [UIColor wp_paragraph];
            textView.font = [UIFont systemFontOfSize:12];
            break;
        }
        default: {
            //do nothing
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


#pragma mark - Table View Protocols

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        return 80;
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}



@end
