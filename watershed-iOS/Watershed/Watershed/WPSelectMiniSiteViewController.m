//
//  WPSelectMiniSiteViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 11/24/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSelectMiniSiteViewController.h"
#import "WPSelectMiniSiteView.h"

@interface WPSelectMiniSiteViewController ()

@property (nonatomic) WPSelectMiniSiteView *view;
@property NSArray *miniSiteArray;

@end

@implementation WPSelectMiniSiteViewController

@synthesize selectSiteDelegate;

static NSString *CellIdentifier = @"Cell";

- (void)loadView {
    self.view = [[WPSelectMiniSiteView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.selectMiniSiteTableView.delegate = self;
    self.view.selectMiniSiteTableView.dataSource = self;
    _miniSiteArray = @[@"Mark's Motel", @"Max's Moat", @"Melissa's Mansion", @"Andrew's Antfarm"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.textLabel.text = [_miniSiteArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor wp_paragraph];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.selectSiteDelegate respondsToSelector:@selector(selectSiteViewControllerDismissed:)]) {
        [self.selectSiteDelegate selectSiteViewControllerDismissed:[self.view.selectMiniSiteTableView cellForRowAtIndexPath:indexPath].textLabel.text];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View Protocols

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_miniSiteArray count];
}


@end
