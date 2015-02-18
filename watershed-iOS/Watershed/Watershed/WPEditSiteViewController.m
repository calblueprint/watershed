//
//  WPEditSiteViewController.m
//  Watershed
//
//  Created by Andrew Millman on 2/17/15.
//  Copyright (c) 2015 Blueprint. All rights reserved.
//

#import "WPEditSiteViewController.h"

@implementation WPEditSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Edit Site";
}

#pragma mark - Private Methods

- (void)preloadFields {
    self.nameTextField.text = self.site.name;
    self.streetTextField.text = self.site.street;
    self.cityTextField.text = self.site.city;
    self.stateTextField.text = self.site.state;
    self.zipCodeTextField.text = self.site.zipCode.stringValue;
    self.descriptionTextView.text = self.site.info;

}

#pragma mark - Setter Methods

- (void)setSite:(WPSite *)site {
    _site = site;
    [self preloadFields];
}

@end
