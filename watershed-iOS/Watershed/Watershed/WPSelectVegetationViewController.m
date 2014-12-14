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

@interface WPSelectVegetationViewController ()
@property (nonatomic) WPSelectVegetationView *view;
@property (nonatomic) NSArray *vegetationList;
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
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(finishSelecting)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.vegetationList = @[@"Tree", @"Plant", @"Bioswale", @"Mark Miyashita", @"Dog", @"Cup", @"Tree", @"Flower", @"Tree", @"Plant", @"Bioswale", @"Mark Miyashita", @"Dog", @"Cup", @"Tree", @"Flower"];
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
    
    if ([self.selectedIndices containsObject:@(indexPath.row)]) {
        [self.view.selectVegetationTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}

#pragma mark - Private Methods

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
    [self.delegate vegetationFinishedSelecting:selectedVegetations withIndices:selectedIndices];
}

#pragma mark - Lazy Instantiation

- (NSArray *)selectedIndices {
    if (!_selectedIndices) {
        _selectedIndices = [[NSArray alloc] init];
    }
    return _selectedIndices;
}

@end
