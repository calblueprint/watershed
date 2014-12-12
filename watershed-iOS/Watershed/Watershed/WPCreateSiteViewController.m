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
#import "WPNetworkingManager.h"

@interface WPCreateSiteViewController ()

@property (nonatomic) WPCreateSiteView *view;
@property (nonatomic) UITableView *infoTableView;
@property (nonatomic) NSArray *textInputViews;
@property (nonatomic) BSKeyboardControls *keyboardControls;

@end

@implementation WPCreateSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = @"New Site";
    
    FAKFontAwesome *closeIcon = [FAKFontAwesome closeIconWithSize:22];
    UIImage *closeImage = [closeIcon imageWithSize:CGSizeMake(22, 22)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:closeImage style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelf)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor wp_blue];
    
    FAKFontAwesome *checkIcon = [FAKFontAwesome checkIconWithSize:22];
    UIImage *checkImage = [checkIcon imageWithSize:CGSizeMake(22, 22)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithImage:checkImage style:UIBarButtonItemStylePlain target:self action:@selector(saveAndDismissSelf)];
    self.navigationItem.rightBarButtonItem = doneButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor wp_blue];
    
    self.keyboardControls.delegate = self;
}

- (void)loadView {
    self.view = [[WPCreateSiteView alloc] init];
    self.infoTableView = self.view.infoTableView;
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
}

- (void)dismissSelf {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveAndDismissSelf {
    NSDictionary *siteJSON = @{
                               @"name" : self.nameTextField.text,
                               @"street" : self.streetTextField.text,
                               @"city" : self.cityTextField.text,
                               @"state" : self.stateTextField.text,
                               @"zip_code" : self.zipCodeTextField.text,
                               @"description" : self.descriptionTextView.text
                               };
    WPSite *site = [MTLJSONAdapter modelOfClass:WPSite.class fromJSONDictionary:siteJSON error:nil];
    
    __weak __typeof(self)weakSelf = self;
    [[WPNetworkingManager sharedManager] createSiteWithSite:site parameters:[[NSMutableDictionary alloc] init] success:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.parent requestAndLoadSites];
        strongSelf.parent = nil;
        [strongSelf dismissSelf];
    }];
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
            cell.textInput = self.nameTextField;
            cell.inputLabel.text = @"Name";
            break;
        }
        // Address
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    cell.textInput = self.streetTextField;
                    cell.inputLabel.text = @"Street";
                    break;
                }
                case 1: {
                    cell.textInput = self.cityTextField;
                    cell.inputLabel.text = @"City";
                    break;
                }
                case 2: {
                    cell.textInput = self.stateTextField;
                    cell.inputLabel.text = @"State";
                    break;
                }
                case 3: {
                    cell.textInput = self.zipCodeTextField;
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
            cell.textInput = self.descriptionTextView;
            cell.inputLabel.text = @"Description";
            break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - BSKeyboardControls Delegate Methods

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls {
    [keyboardControls.activeField resignFirstResponder];
    [self.infoTableView setContentOffset:CGPointMake(0, -topMargin) animated:YES];
}

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls
           selectedField:(UIView *)field
             inDirection:(BSKeyboardControlsDirection)direction {
    CGFloat offsetY = [field convertRect:field.frame toView:self.infoTableView].origin.y - topMargin - [WPCreateSiteTableViewCell cellHeight];
    CGPoint offset = CGPointMake(0, offsetY);
    [self.infoTableView setContentOffset:offset animated:YES];
}

#pragma mark - TextField Delegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.keyboardControls.activeField = textField;
    //ignore direction in here
    [self keyboardControls:self.keyboardControls selectedField:textField inDirection:BSKeyboardControlsDirectionNext];
    return YES;
}

#pragma mark - TextView Delegate Methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.keyboardControls.activeField = textView;
    //ignore direction in here
    [self keyboardControls:self.keyboardControls selectedField:textView inDirection:BSKeyboardControlsDirectionNext];
    return YES;
}

#pragma mark - Lazy Instantiation

- (BSKeyboardControls *)keyboardControls {
    if (!_keyboardControls) {
        _keyboardControls = [[BSKeyboardControls alloc] initWithFields:self.textInputViews];
    }
    return _keyboardControls;
}

- (NSArray *)textInputViews {
    if (!_textInputViews) {
        _textInputViews = @[
                            self.nameTextField,
                            self.streetTextField,
                            self.cityTextField,
                            self.stateTextField,
                            self.zipCodeTextField,
                            self.descriptionTextView
                            ];
    }
    return _textInputViews;
}

- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.delegate = self;
    }
    return _nameTextField;
}

- (UITextField *)streetTextField {
    if (!_streetTextField) {
        _streetTextField = [[UITextField alloc] init];
        _streetTextField.delegate = self;
    }
    return _streetTextField;
}

- (UITextField *)cityTextField {
    if (!_cityTextField) {
        _cityTextField = [[UITextField alloc] init];
        _cityTextField.delegate = self;
    }
    return _cityTextField;
}

- (UITextField *)stateTextField {
    if (!_stateTextField) {
        _stateTextField = [[UITextField alloc] init];
        _stateTextField.delegate = self;
    }
    return _stateTextField;
}

- (UITextField *)zipCodeTextField {
    if (!_zipCodeTextField) {
        _zipCodeTextField = [[UITextField alloc] init];
        _zipCodeTextField.delegate = self;
    }
    return _zipCodeTextField;
}

- (UITextView *)descriptionTextView {
    if (!_descriptionTextView) {
        _descriptionTextView = [[UITextView alloc] init];
        _descriptionTextView.font = [UIFont systemFontOfSize:17.0];
        _descriptionTextView.delegate = self;
    }
    return _descriptionTextView;
}

@end
