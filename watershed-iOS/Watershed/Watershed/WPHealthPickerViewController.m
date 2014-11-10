//
//  WPHealthPickerViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 11/9/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPHealthPickerViewController.h"

@interface WPHealthPickerViewController ()

@property (nonatomic) NSMutableArray *pickerData;
@property (nonatomic) UIPickerView *healthRatingPicker;

@end

@implementation WPHealthPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    int ratingMax = 5; //Change this if you want higher ratings
    _pickerData = [[NSMutableArray alloc] init];
    for(int i = 0; i < ratingMax; i++)
    {
        [_pickerData addObject:[NSNumber numberWithInt:i]];
    }
    _healthRatingPicker = [[UIPickerView alloc] init];
    _healthRatingPicker.delegate = self;
}

-(NSString*) pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_pickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
