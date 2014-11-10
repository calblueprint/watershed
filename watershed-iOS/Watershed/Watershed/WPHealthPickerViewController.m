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
//    _healthRatingPicker = [[UIPickerView alloc] init];
    _healthRatingPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 200, 300, 200)];
    _healthRatingPicker.showsSelectionIndicator = YES;
    _healthRatingPicker.delegate = self;
    _healthRatingPicker.dataSource = self;
    [self.view addSubview:_healthRatingPicker];
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

