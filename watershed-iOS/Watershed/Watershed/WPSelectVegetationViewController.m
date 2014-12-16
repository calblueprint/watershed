//
//  WPSelectVegetationViewController.m
//  Watershed
//
//  Created by Andrew Millman on 12/13/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSelectVegetationViewController.h"
#import "WPSelectVegetationView.h"
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
    
    self.vegetationList = @[@"Tree", @"Plant", @"Bioswale", @"Mark Miyashita"];
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
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.vegetationList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Private Methods

- (void)finishSelecting {
    [self.delegate vegetationFinishedSelecting:self.vegetationList];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
