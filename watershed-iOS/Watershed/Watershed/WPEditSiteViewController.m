//
//  WPEditSiteViewController.m
//  Watershed
//
//  Created by Andrew Millman on 2/17/15.
//  Copyright (c) 2015 Blueprint. All rights reserved.
//

#import "WPEditSiteViewController.h"
#import "WPNetworkingManager.h"

@implementation WPEditSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Edit Site";
}

// Override
- (void)saveAndDismissSelf {
    NSDictionary *siteJSON = @{
                               @"name" : self.nameTextField.text,
                               @"street" : self.streetTextField.text,
                               @"city" : self.cityTextField.text,
                               @"state" : self.stateTextField.text,
                               @"zip_code" : self.zipCodeTextField.text,
                               @"description" : self.descriptionTextView.text
                               };
    WPSite *newSite = [MTLJSONAdapter modelOfClass:WPSite.class fromJSONDictionary:siteJSON error:nil];
    newSite.siteId = self.site.siteId;
    [self updateServerWithSite:newSite];
}

// Override
- (void)updateServerWithSite:(WPSite *)site {
    // Don't request the list of sites, because it is already called in the ViewController's viewWillAppear
    __weak __typeof(self)weakSelf = self;
    [[WPNetworkingManager sharedManager] editSiteWithSite:site parameters:[[NSMutableDictionary alloc] init] success:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf dismissSelf];
    }];
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
