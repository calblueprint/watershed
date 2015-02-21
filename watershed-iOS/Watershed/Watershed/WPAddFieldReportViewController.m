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

@end

@implementation WPAddFieldReportViewController

-(void)loadView {
    self.view = [[WPAddFieldReportView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Add Field Report";
    self.view.fieldReportTableView.delegate = self;
    self.view.fieldReportTableView.dataSource = self;
    [self.view.addPhotoButton addTarget:self action:@selector(addPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view.viewImageButton addTarget:self action:@selector(viewImageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view.urgentSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Save"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(saveForm)];
    self.navigationItem.rightBarButtonItem = saveButton;
    self.view.fieldDescription.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(dismissKeyboard)];
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

-(void)dismissKeyboard {
    if([self.view.fieldDescription isFirstResponder]) {
        [self.view.fieldDescription resignFirstResponder];
    }
}

- (void)saveForm {
    [self dismissKeyboard];
    NSString *userId = [[WPNetworkingManager sharedManager] keyChainStore][@"user_id"];
    NSString *fieldReportDescription = self.view.fieldDescription.text;
    NSNumber *healthRating;
    if (self.view.rating1.isSelected) {
        healthRating = @1;
    } else if (self.view.rating2.isSelected) {
        healthRating = @2;
    } else if (self.view.rating3.isSelected) {
        healthRating = @3;
    } else if (self.view.rating4.isSelected) {
        healthRating = @4;
    } else if (self.view.rating5.isSelected) {
        healthRating = @5;
    }
    NSNumber *urgent = @(self.view.urgentSwitch.isOn);
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
//        miniSiteId = parent.miniSiteId;
    }
    NSString *photo = [UIImagePNGRepresentation([self compressForUpload:self.view.selectedImageView.image withScale:0.2]) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];;
    
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
        if ([parent isKindOfClass:[WPMiniSiteViewController class]]) {
            [(WPMiniSiteViewController *)parent requestAndLoadMiniSite];
        }
        [self.navigationController popViewControllerAnimated:YES];
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

- (void)viewImageButtonAction:(UIButton *)sender {
    self.viewPhotoModal = [[UIViewController alloc] init];
    self.viewPhotoModal.view.backgroundColor = [UIColor blackColor];
    self.viewPhotoModal.view.userInteractionEnabled = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.viewPhotoModal.view.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = self.view.selectedImageView.image;
    
    [self.viewPhotoModal.view addSubview:imageView];
    
    UITapGestureRecognizer *modalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissModalView)];
    [self.viewPhotoModal.view addGestureRecognizer:modalTap];
    self.viewPhotoModal.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:self.viewPhotoModal animated:YES completion:nil];
}

- (void)dismissModalView {
    [self.viewPhotoModal dismissViewControllerAnimated:YES completion:nil];
}

- (void)setBlurredImage {
    self.view.blurredImage = [self.view.originalImage applyBlurWithRadius:5 tintColor:[UIColor clearColor] saturationDeltaFactor:1 maskImage:nil];
    self.view.selectedImageView.image = self.view.blurredImage;
}

- (void)addPhotoButtonAction:(UIButton *)sender {
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending)) {
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Take Photo",
                                @"Choose Existing",
                                nil];
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
        
        
        [addPhotoActionSheet addAction:takePhoto];
        [addPhotoActionSheet addAction:selectPhoto];
        [addPhotoActionSheet addAction:cancel];
        [self presentViewController:addPhotoActionSheet animated:YES completion:nil];
    }
}

- (void)actionSheet:(UIActionSheet *)popup
clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self takePhoto];
                    break;
                case 1:
                    [self chooseExisting];
                    break;
                default:
                    break;
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
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Table View Delegate / Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2 || indexPath.row == 3) {
        return 120;
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
            UISwitch *urgentSwitch = [[UISwitch alloc] init];
            urgentSwitch.onTintColor = [UIColor wp_red];
            cell = [[WPAddFieldReportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andControl:urgentSwitch];
            cell.label.text = @"Urgent";
            break;
        }
        case 1: {
            UITextField *ratingField = [[UITextField alloc] init];
            ratingField.delegate = self;
            ratingField.placeholder = @"1-5";
            ratingField.tag = 1;
            ratingField.textColor = [UIColor wp_paragraph];
            ratingField.font = [UIFont systemFontOfSize:16];
            cell = [[WPAddFieldReportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andControl:ratingField];
            cell.label.text = @"Rating";
            break;
        }
        case 2: {
            UITextView *descriptionView = [[UITextView alloc] init];
            cell = [[WPAddFieldReportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andControl:descriptionView];
            cell.label.text = @"Description";
            descriptionView.textColor = [UIColor wp_paragraph];
            descriptionView.font = [UIFont systemFontOfSize:12];
            break;            break;
        }
        default: {
            //do nothing
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.view.selectedImageView.image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Text Field delegate methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


@end


