//
//  WPAddFieldReportViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 10/29/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPAddFieldReportViewController.h"
#import "WPAddFieldReportView.h"

@interface WPAddFieldReportViewController ()

@property (nonatomic) NSMutableArray *pickerData;
@property (nonatomic) WPAddFieldReportView *view;
@end

@implementation WPAddFieldReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.addPhotoButton addTarget:self action:@selector(addPhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    int ratingMax = 5; //Change this if you want higher ratings
    _pickerData = [[NSMutableArray alloc] init];
    for(int i = 0; i < ratingMax; i++)
    {
        [_pickerData addObject:[NSNumber numberWithInt:i]];
    }
    self.view.healthRatingPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 200, 300, 200)];
    self.view.healthRatingPicker.showsSelectionIndicator = YES;
    self.view.healthRatingPicker.delegate = self;
    self.view.healthRatingPicker.dataSource = self;
    self.view.ratingField.inputView = self.view.healthRatingPicker;
}

-(void)loadView {
    self.view = [[WPAddFieldReportView alloc] init];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showPickerView {
    int ratingMax = 5; //Change this if you want higher ratings
    _pickerData = [[NSMutableArray alloc] init];
    for(int i = 0; i < ratingMax; i++)
    {
        [_pickerData addObject:[NSNumber numberWithInt:i]];
    }
    //    _healthRatingPicker = [[UIPickerView alloc] init];
    self.view.healthRatingPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 200, 300, 200)];
    self.view.healthRatingPicker.showsSelectionIndicator = YES;
    self.view.healthRatingPicker.delegate = self;
    self.view.healthRatingPicker.dataSource = self;
    [self.view.healthRatingPicker  setShowsSelectionIndicator:YES];
    self.view.ratingField.inputView = self.view.healthRatingPicker;

}


- (void)addPhotoButtonAction:(UIButton *) sender {
    UIAlertController *addPhotoActionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhoto = [UIAlertAction
                         actionWithTitle:@"Take Photo"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [addPhotoActionSheet dismissViewControllerAnimated:YES completion:nil];
                                 if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                     UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                     [myAlertView show];
                                 } else {
                                     
                                     UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                     picker.delegate = self;
                                     picker.allowsEditing = YES;
                                     picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                     
                                     [self presentViewController:picker animated:YES completion:NULL]; 
                                 }

                         }];
    UIAlertAction *selectPhoto = [UIAlertAction
                                actionWithTitle:@"Choose Existing"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [addPhotoActionSheet dismissViewControllerAnimated:YES completion:nil];
                                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                    picker.delegate = self;
                                    picker.allowsEditing = YES;
                                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                    
                                    [self presentViewController:picker animated:YES completion:NULL];
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


#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.view.selectedImageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_pickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    self.view.ratingField.text = (NSString *)[_pickerData objectAtIndex:row];

    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

@end
