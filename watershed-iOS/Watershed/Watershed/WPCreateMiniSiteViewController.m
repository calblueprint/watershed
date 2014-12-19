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
#import "WPNetworkingManager.h"

@interface WPCreateMiniSiteViewController ()

@property (nonatomic) WPCreateMiniSiteView *view;
@property (nonatomic) UITableView *infoTableView;
@property (nonatomic) NSArray *textInputViews;
@property (nonatomic) NSArray *selectedVegetations;
@property (nonatomic) NSArray *selectedVegetationIndices;
@property (nonatomic) BSKeyboardControls *keyboardControls;

@end

@implementation WPCreateMiniSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor wp_blue];
    self.title = @"New Mini Site";
    
    // Add white background to status bar
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [WPView getScreenWidth], 20)];
    statusBarView.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    FAKFontAwesome *closeIcon = [FAKFontAwesome closeIconWithSize:22];
    UIImage *closeImage = [closeIcon imageWithSize:CGSizeMake(22, 22)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:closeImage style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelf)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    FAKFontAwesome *checkIcon = [FAKFontAwesome checkIconWithSize:22];
    UIImage *checkImage = [checkIcon imageWithSize:CGSizeMake(22, 22)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithImage:checkImage style:UIBarButtonItemStylePlain target:self action:@selector(saveAndDismissSelf)];
    self.navigationItem.rightBarButtonItem = doneButton;
   
    [self.imageInputCell.viewImageButton addTarget:self action:@selector(presentImageView) forControlEvents:UIControlEventTouchUpInside];
    
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
    NSDictionary *miniSiteJSON = @{
                                   @"name" : self.nameTextField.text,
                                   @"street" : self.streetTextField.text,
                                   @"city" : self.cityTextField.text,
                                   @"state" : self.stateTextField.text,
                                   @"zip_code" : self.zipCodeTextField.text,
                                   @"description" : self.descriptionTextView.text,
                                   @"vegetations" : self.selectedVegetations
                                   };
    WPMiniSite *miniSite = [MTLJSONAdapter modelOfClass:WPMiniSite.class fromJSONDictionary:miniSiteJSON error:nil];
    miniSite.site = self.parent.site;
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSString *photo = [UIImagePNGRepresentation([self compressForUpload:self.imageInputCell.imageInput.image withScale:0.2]) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    parameters[@"photos_attributes"] = @[ @{ @"data" : photo } ];
    
    __weak __typeof(self)weakSelf = self;
    [[WPNetworkingManager sharedManager] createMiniSiteWithMiniSite:miniSite parameters:parameters success:^(WPMiniSite *miniSite) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.parent requestAndLoadSite];
        strongSelf.parent = nil;
        [strongSelf dismissSelf];
    }];
}

- (UIImage *)compressForUpload:(UIImage *)original withScale:(CGFloat)scale {
    // Calculate new size given scale factor.
    CGSize originalSize = original.size;
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
    // Scale the original image to match the new size.
    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage;
}

#pragma mark - Table View Delegate / Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        // Address grouping
        case 1: {
            return 4;
            break;
        }
        default: {
            return 1;
            break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Description cell
    if (indexPath.section == 2) {
        return [WPCreateMiniSiteTableViewCell cellDescriptionHeight];
    }
    //Uploading Photo
    else if (indexPath.section == 4) {
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
        // Vegetation
        case 3: {
            cell.textInput = self.vegetationTextField;
            cell.inputLabel.text = @"Vegetation";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        // MiniSite Photo
        case 4: {
            return self.imageInputCell;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) {
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
    
    // select vegetation
    if (textField.tag == 1) {
        WPSelectVegetationViewController *selectVegetationViewController = [[WPSelectVegetationViewController alloc] init];
        selectVegetationViewController.delegate = self;
        selectVegetationViewController.selectedIndices = self.selectedVegetationIndices;
        [self.navigationController pushViewController:selectVegetationViewController animated:YES];
        return NO;
    }
    
    self.keyboardControls.activeField = textField;

    self.keyboardControls.activeField = textField;
    // ignore direction in here
    [self keyboardControls:self.keyboardControls selectedField:textField inDirection:BSKeyboardControlsDirectionNext];
    return YES;
}

#pragma mark - TextView Delegate Methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.keyboardControls.activeField = textView;
    // ignore direction in here
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
                                         self.imageInputCell.viewImageButton.alpha = 0;
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
                self.imageInputCell.viewImageButton.alpha = 0;
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

#pragma mark - SelectVegetation Delegate

- (void)vegetationFinishedSelecting:(NSArray *)vegetations withIndices:(NSArray *)indices {
    self.vegetationTextField.text = nil;
    for (NSString *vegetationItem in vegetations) {
        if ([vegetations indexOfObject:vegetationItem] > 0) {
            NSString *addOn = [@", " stringByAppendingString:vegetationItem];
            self.vegetationTextField.text = [self.vegetationTextField.text stringByAppendingString:addOn];
        } else {
            self.vegetationTextField.text = vegetationItem;
        }
    }
    
    self.selectedVegetations = vegetations;
    self.selectedVegetationIndices = indices;
}

#pragma mark - ImagePickerController delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.imageInputCell.imageInput.image = info[UIImagePickerControllerOriginalImage];
    self.imageInputCell.viewImageButton.alpha = 1;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Photo Viewing Methods

- (void)presentImageView {
    UIViewController *viewPhotoModal = [[UIViewController alloc] init];
    viewPhotoModal.view.backgroundColor = [UIColor blackColor];
    viewPhotoModal.view.userInteractionEnabled = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:viewPhotoModal.view.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = self.imageInputCell.imageInput.image;
    [viewPhotoModal.view addSubview:imageView];
    
    UITapGestureRecognizer *modalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissModalView:)];
    [viewPhotoModal.view addGestureRecognizer:modalTap];
    viewPhotoModal.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self presentViewController:viewPhotoModal animated:YES completion:nil];
}

- (void)dismissModalView:(UIGestureRecognizer *)sender {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (UITextField *)vegetationTextField {
    if (!_vegetationTextField) {
        _vegetationTextField = [[UITextField alloc] init];
        _vegetationTextField.placeholder = @"Select Vegetation";
        _vegetationTextField.tag = 1;
        _vegetationTextField.delegate = self;
    }
    return _vegetationTextField;
}

- (WPCreateMiniSiteImageTableViewCell *) imageInputCell {
    if (!_imageInputCell) {
        _imageInputCell = [[WPCreateMiniSiteImageTableViewCell alloc] init];
        _imageInputCell.inputLabel.text = @"Photo";
    }
    return _imageInputCell;
}

- (NSArray *)selectedVegetations {
    if (!_selectedVegetations) {
        _selectedVegetations = [[NSArray alloc] init];
    }
    return _selectedVegetations;
}

- (NSArray *)selectedVegetationIndices {
    if (!_selectedVegetationIndices) {
        _selectedVegetationIndices = [[NSArray alloc] init];
    }
    return _selectedVegetationIndices;
}

@end
