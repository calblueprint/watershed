//
//  WPSelectVegetationViewController.m
//  Watershed
//
//  Created by Andrew Millman on 12/13/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSelectVegetationViewController.h"
#import "WPSelectVegetationView.h"
#import "WPSelectVegetationTableViewCell.h"
#import "UIExtensions.h"

@interface WPSelectVegetationViewController () <UITextFieldDelegate>
@property (nonatomic) WPSelectVegetationView *view;
@property (nonatomic) UITextField *addVegetationTextField;
@end

@implementation WPSelectVegetationViewController

static NSString *cellIdentifier = @"VegetationCell";

- (void)loadView {
    self.view = [[WPSelectVegetationView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Select Vegetation";
    self.view.selectVegetationTableView.delegate = self;
    self.view.selectVegetationTableView.dataSource = self;
    
    // Set up Add Vegetation Text Field Response
    self.addVegetationTextField = self.view.addVegetationTextField.textField;
    self.addVegetationTextField.delegate = self;
    [self.view.addVegetationTextField.addButton addTarget:self
                                                   action:@selector(addVegetation)
                                         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(finishSelecting)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
}

#pragma mark - Table View Delegate / Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.vegetationList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WPSelectVegetationTableViewCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    WPSelectVegetationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[WPSelectVegetationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.vegetationList[indexPath.row];
    
    NSNumber *currentRow = @(indexPath.row);
    if (self.initialSelectedIndices.count && [self.initialSelectedIndices containsObject:currentRow]) {
        [self.view.selectVegetationTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        // Remove selected Index to prevent object from reselecting itself during reuse
        [self.initialSelectedIndices removeObject:currentRow];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
}

#pragma mark - ScrollView Delegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self dismissKeyboard];
}

#pragma mark - TextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self addVegetation];
    return NO;
}

#pragma mark - Private Methods

- (void)dismissKeyboard {
    [self.addVegetationTextField resignFirstResponder];
}

- (void)addVegetation {
    NSString *vegetation = self.addVegetationTextField.text;
    self.addVegetationTextField.text = @"";
    
    if (vegetation.length) {
        [self dismissKeyboard];
        [self.vegetationList insertObject:vegetation atIndex:0];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.view.selectVegetationTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                                   withRowAnimation:UITableViewRowAnimationTop];
        [self.view.selectVegetationTableView selectRowAtIndexPath:newIndexPath
                                                         animated:YES
                                                   scrollPosition:UITableViewScrollPositionTop];
    } else {
        [self.addVegetationTextField becomeFirstResponder];
    }
}

- (void)finishSelecting {
    [self getSelectedVegetation];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getSelectedVegetation {
    NSArray *selectedRows = [self.view.selectVegetationTableView indexPathsForSelectedRows];
    NSMutableArray *selectedIndices = [[NSMutableArray alloc] init];
    NSMutableArray *selectedVegetations = [[NSMutableArray alloc] init];

    for (NSIndexPath *index in selectedRows) {
        [selectedIndices addObject:@(index.row)];
        NSString *selectedItem = self.vegetationList[index.row];
        [selectedVegetations addObject:selectedItem];
    }
    [self.delegate vegetationFinishedSelectingFromList:self.vegetationList vegetations:selectedVegetations indices:selectedIndices];
}

#pragma mark - Lazy Instantiation

- (NSMutableArray *)selectedIndices {
    if (!_initialSelectedIndices) {
        _initialSelectedIndices = [[NSMutableArray alloc] init];
    }
    return _initialSelectedIndices;
}

@end
