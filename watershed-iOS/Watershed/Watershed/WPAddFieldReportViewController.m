//
//  WPAddFieldReportViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 10/29/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPAddFieldReportViewController.h"
#import "WPAddFieldReportView.h"
#import "WPNetworkingManager.h"
#import "WPMiniSiteViewController.h"
#import "WPTaskViewController.h"
#import "WPAddFieldReportTableViewCell.h"

@interface WPAddFieldReportViewController ()

@property (nonatomic) NSMutableArray *pickerData;
@property (nonatomic) WPAddFieldReportView *view;
@property (nonatomic) UIViewController *viewPhotoModal;
@property (nonatomic) UITextField *ratingField;
@property (nonatomic) UITextView *descriptionView;
@property (nonatomic) UISwitch *urgentSwitch;

@end

@implementation WPAddFieldReportViewController

- (void)loadView {
    self.view = [[WPAddFieldReportView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Add Field Report";
    self.view.fieldReportTableView.delegate = self;
    self.view.fieldReportTableView.dataSource = self;
    [self.urgentSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Save"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(saveForm)];
    self.navigationItem.rightBarButtonItem = saveButton;
    self.view.fieldDescription.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.imageInputCell.viewImageButton addTarget:self action:@selector(presentImageView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)changeSwitch:(UISwitch *)sender {
    if ([sender isOn]) {
        //MIGHT USE LATER
    }
}

- (void)dismissKeyboard {
    [self.descriptionView resignFirstResponder];
    [self.ratingField resignFirstResponder];
}

- (BOOL)getValidRating {
    int test = [self.ratingField.text intValue];
    return test >= 1 && test <= 5;
}


- (void)saveForm {
    [self dismissKeyboard];
    BOOL isValidRating = [self getValidRating];
    if (self.ratingField.text.length == 0 || self.descriptionView.text.length == 0 || !self.imageInputCell.imageInputView.image || !isValidRating) {
        NSString *errorMessage = @"All fields must be filled out.";
        if (!isValidRating) {
            errorMessage = @"Rating must be a number between 1 and 5.";
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:errorMessage
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        NSString *userId = [[WPNetworkingManager sharedManager] keyChainStore][@"user_id"];
        NSString *fieldReportDescription = self.descriptionView.text;
        NSNumber *healthRating = [NSNumber numberWithInt:[self.ratingField.text intValue]];
        NSNumber *urgent = @(self.urgentSwitch.isOn);
        //  if parent is task VC, do task id, otherwise to nil
        NSNumber *taskId;
        NSString *miniSiteId;
        UIViewController *parent;
        UIViewController *previousViewController = [((UINavigationController *)self.parentViewController).viewControllers objectAtIndex:((UINavigationController *)self.parentViewController).viewControllers.count-2];
        if ([previousViewController isKindOfClass:[WPMiniSiteViewController class]]) {
            parent = previousViewController;
            miniSiteId = [((WPMiniSiteViewController *)parent).miniSite.miniSiteId stringValue];
            taskId = nil;
        } else if ([previousViewController isKindOfClass:[WPTaskViewController class]]) {
            parent = (WPTaskViewController *)previousViewController;
            //        taskId = parent.taskId;
            miniSiteId = [((WPTaskViewController *)parent).task.miniSite.miniSiteId stringValue];
        }
        NSString *photo = [UIImagePNGRepresentation([self compressForUpload:self.imageInputCell.imageInputView.image withScale:0.2]) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        NSDictionary *staticParameters = @{@"field_report": @{
                                                   @"user_id": userId,
                                                   @"mini_site_id": miniSiteId,
                                                   @"description": fieldReportDescription,
                                                   @"health_rating": healthRating,
                                                   @"urgent": urgent,
                                                   @"photo_attributes": @{
                                                           @"data": photo
                                                           }
                                                   }};
        NSMutableDictionary *parameters = [staticParameters mutableCopy];
        
        [[WPNetworkingManager sharedManager] postFieldReportWithParameters:parameters success:^(WPFieldReport *fieldReport) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
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

#pragma mark - Photo Viewing Methods

- (void)presentImageView {
    UIViewController *viewPhotoModal = [[UIViewController alloc] init];
    viewPhotoModal.view.backgroundColor = [UIColor blackColor];
    viewPhotoModal.view.userInteractionEnabled = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:viewPhotoModal.view.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = self.imageInputCell.imageInputView.image;
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

- (void)setBlurredImage {
    self.view.blurredImage = [self.view.originalImage applyBlurWithRadius:5 tintColor:[UIColor clearColor] saturationDeltaFactor:1 maskImage:nil];
    self.view.selectedImageView.image = self.view.blurredImage;
}

- (void)addPhotoButtonAction {
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending)) {
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Take Photo",
                                @"Choose Existing",
                                nil];
        if (self.imageInputCell.imageInputView.image) {
            popup.destructiveButtonIndex = [popup addButtonWithTitle:@"Remove Photo"];
        }
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
        if (self.imageInputCell.imageInputView.image) {
            UIAlertAction *remove = [UIAlertAction
                                     actionWithTitle:@"Remove Photo"
                                     style:UIAlertActionStyleDestructive
                                     handler:^(UIAlertAction * action)
                                     {
                                         self.imageInputCell.imageInputView.image = nil;
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

#pragma mark - ActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)popup
clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger buttonShift = popup.numberOfButtons - 3;
    switch (popup.tag) {
        case 1: {
            if (buttonIndex == popup.destructiveButtonIndex && buttonShift == 1) {
                self.imageInputCell.imageInputView.image = nil;
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

- (void)takePhoto {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [myAlertView show];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
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
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Table View Delegate / Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        return 120;
    }
    else if (indexPath.row == 3) {
        return [WPCreateMiniSiteImageTableViewCell cellHeight];
    }
    else {
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"Cell";
    
    WPAddFieldReportTableViewCell *cell = [[WPAddFieldReportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    switch (indexPath.row) {
            // Urgent
        case 0: {
            _urgentSwitch = [[UISwitch alloc] init];
            _urgentSwitch.onTintColor = [UIColor wp_red];
            cell = [[WPAddFieldReportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andControl:_urgentSwitch];
            cell.label.text = @"Urgent";
            break;
        }
        case 1: {
            _ratingField = [[UITextField alloc] init];
            _ratingField.delegate = self;
            _ratingField.placeholder = @"1-5";
            _ratingField.tag = 1;
            _ratingField.textColor = [UIColor wp_paragraph];
            _ratingField.font = [UIFont systemFontOfSize:16];
            cell = [[WPAddFieldReportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andControl:_ratingField];
            cell.label.text = @"Rating";
            break;
        }
        case 2: {
            _descriptionView = [[UITextView alloc] init];
            cell = [[WPAddFieldReportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andControl:_descriptionView];
            cell.label.text = @"Description";
            _descriptionView.textColor = [UIColor wp_paragraph];
            _descriptionView.font = [UIFont systemFontOfSize:12];
            break;            break;
        }
        case 3: {
            return self.imageInputCell;
        }
        default: {
            //do nothing
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"HELLO>????");
    if (indexPath.row == 3) {
        [self addPhotoButtonAction];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];}


#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.imageInputCell.imageInputView.image = info[UIImagePickerControllerOriginalImage];
    self.imageInputCell.viewImageButton.alpha = 1;
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - Text Field delegate methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Lazy Instantiation

- (WPCreateMiniSiteImageTableViewCell *) imageInputCell {
    if (!_imageInputCell) {
        _imageInputCell = [[WPCreateMiniSiteImageTableViewCell alloc] init];
        _imageInputCell.inputLabel.text = @"Photo";
    }
    return _imageInputCell;
}


@end


