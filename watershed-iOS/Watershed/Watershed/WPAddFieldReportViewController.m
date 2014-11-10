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
    //    _healthRatingPicker = [[UIPickerView alloc] init];
    self.view.healthRatingPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 200, 300, 200)];
    self.view.healthRatingPicker.showsSelectionIndicator = YES;
    self.view.healthRatingPicker.delegate = self;
    self.view.healthRatingPicker.dataSource = self;
}

-(void)loadView {
    self.view = [[WPAddFieldReportView alloc] init];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
                         }];
    UIAlertAction *selectPhoto = [UIAlertAction
                                actionWithTitle:@"Choose Existing"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [addPhotoActionSheet dismissViewControllerAnimated:YES completion:nil];
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

-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_pickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    
}

// tell the picker the width of each row for a given component
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
