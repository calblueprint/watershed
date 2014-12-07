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
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"Add Field Report";
    [self.view.addPhotoButton addTarget:self action:@selector(addPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view.viewImageButton addTarget:self action:@selector(viewImageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view.urgentSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Save"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(saveForm:)];
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

- (void)saveForm:(UIButton *)sender {
    [self dismissKeyboard];
    WPFieldReport *fieldReport = [[WPFieldReport alloc] init];
    NSString *userId = [[WPNetworkingManager sharedManager] keyChainStore][@"userId"];
//    NSString *miniSiteId = self.parentViewController; //get minisite id
    NSString *description = self.view.fieldDescription.text;
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
    BOOL urgent = self.view.urgentSwitch.isOn;
//  if parent is task VC, do task id, otherwise to nil
    NSNumber *taskId;
    if ([self.parentViewController isKindOfClass:[WPMiniSiteViewController class]]) {
        taskId = nil;
    } else if ([self.parentViewController isKindOfClass:[WPTaskViewController class]]) {
        WPTaskViewController *parent = (WPTaskViewController *)self.parentViewController;
//        taskId = parent.taskId;
    }
    NSDictionary *parameters = @{@"user_id": userId};
    
    [[WPNetworkingManager sharedManager] postFieldReportWithParameters:parameters success:^(WPFieldReport *fieldReport) {
        //do stuffs
    }];
}

- (void)viewImageButtonAction:(UIButton *)sender {
    self.viewPhotoModal = [[UIViewController alloc] init];
    self.viewPhotoModal.view.backgroundColor = [UIColor blackColor];
    self.viewPhotoModal.view.userInteractionEnabled = YES;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.viewPhotoModal.view.frame];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
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


#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.view.selectedImageView.image = info[UIImagePickerControllerOriginalImage];
//    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
//    self.view.originalImage = chosenImage;
//    [self setBlurredImage];
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


