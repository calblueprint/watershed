//
//  WPCreateMiniSiteViewController.m
//  Watershed
//
//  Created by Andrew Millman on 12/9/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPCreateMiniSiteViewController.h"
#import "WPCreateMiniSiteView.h"
#import "WPCreateMiniSiteTableViewCell.h"
#import "WPView.h"

@interface WPCreateMiniSiteViewController ()

@property (nonatomic) WPCreateMiniSiteView *view;
@property (nonatomic) UITableView *infoTableView;
@property (nonatomic) NSArray *textInputViews;
@property (nonatomic) BSKeyboardControls *keyboardControls;

@end

@implementation WPCreateMiniSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = @"New Mini Site";
    
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
    self.view = [[WPCreateMiniSiteView alloc] init];
    self.infoTableView = self.view.infoTableView;
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
}

- (void)dismissSelf {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveAndDismissSelf {
}

#pragma mark - Table View Delegate / Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
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
        case 3: {
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
        return [WPCreateMiniSiteTableViewCell cellDescriptionHeight];
    }
    else if (indexPath.section == 3) {
        return [WPCreateMiniSiteImageTableViewCell cellHeight];
    }
    else {
        return [WPCreateMiniSiteTableViewCell cellHeight];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPCreateMiniSiteTableViewCell *cell = [[WPCreateMiniSiteTableViewCell alloc] init];
    
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
            // MiniSite Photo
        case 3: {
            return self.imageInputCell;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        [self presentPhotoButtonAction];
    }
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
    CGFloat offsetY = [field convertRect:field.frame toView:self.infoTableView].origin.y - topMargin - [WPCreateMiniSiteTableViewCell cellHeight];
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

#pragma mark - Photo Selection Methods

- (void)presentPhotoButtonAction {
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending)) {
        UIActionSheet *popup = [[UIActionSheet alloc] init];
        if (self.imageInputCell.imageInput.image) {
            popup.destructiveButtonIndex = [popup addButtonWithTitle:@"Remove Photo"];
        }
        [popup addButtonWithTitle:@"Take Photo"];
        [popup addButtonWithTitle:@"Choose Existing"];
        popup.cancelButtonIndex = [popup addButtonWithTitle:@"Cancel"];
        popup.delegate = self;
        popup.tag = 1;
        [popup showInView:[UIApplication sharedApplication].keyWindow];
    } else {
        UIAlertController *addPhotoActionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                                     message:nil
                                                                              preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *takePhoto = [UIAlertAction
                                    actionWithTitle:@"Take Photo"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        [addPhotoActionSheet dismissViewControllerAnimated:YES completion:nil];
                                        [self takePhoto];
                                        
                                    }];
        UIAlertAction *selectPhoto = [UIAlertAction
                                      actionWithTitle:@"Choose Existing"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action)
                                      {
                                          [addPhotoActionSheet dismissViewControllerAnimated:YES completion:nil];
                                          [self chooseExisting];
                                          
                                      }];
        UIAlertAction *cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                 {
                                     [addPhotoActionSheet dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        if (self.imageInputCell.imageInput.image) {
            UIAlertAction *remove = [UIAlertAction
                                     actionWithTitle:@"Remove Photo"
                                     style:UIAlertActionStyleDestructive
                                     handler:^(UIAlertAction * action)
                                     {
                                         self.imageInputCell.imageInput.image = nil;
                                         [addPhotoActionSheet dismissViewControllerAnimated:YES completion:nil];
                                     }];
            [addPhotoActionSheet addAction:remove];
        }
        
        [addPhotoActionSheet addAction:takePhoto];
        [addPhotoActionSheet addAction:selectPhoto];
        [addPhotoActionSheet addAction:cancel];
        [self presentViewController:addPhotoActionSheet animated:YES completion:nil];
    }
}

- (void)takePhoto {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [myAlertView show];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)chooseExisting {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [picker.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [picker.navigationBar setShadowImage:[UIImage imageNamed:@"WPBlue"]];
    [picker.navigationBar setTintColor:[UIColor wp_blue]];
    [picker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [WPView getScreenWidth], 20)];
    statusBarView.backgroundColor = [UIColor whiteColor];
    [picker.view addSubview:statusBarView];
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - ActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)popup
clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger buttonShift = popup.numberOfButtons - 3;
    switch (popup.tag) {
        case 1: {
            if (buttonIndex == popup.destructiveButtonIndex && buttonShift == 1) {
                self.imageInputCell.imageInput.image = nil;
            }
            else if (buttonIndex == 0 + buttonShift) {
                [self takePhoto];
            } else if (buttonIndex == 1 + buttonShift) {
                [self chooseExisting];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - ImagePickerController delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.imageInputCell.imageInput.image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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

- (WPCreateMiniSiteImageTableViewCell *) imageInputCell {
    if (!_imageInputCell) {
        _imageInputCell = [[WPCreateMiniSiteImageTableViewCell alloc] init];
        _imageInputCell.inputLabel.text = @"Photo";
    }
    return _imageInputCell;
}

@end
