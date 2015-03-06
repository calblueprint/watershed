//
//  WPEditMiniSiteViewController.m
//  Watershed
//
//  Created by Andrew Millman on 2/19/15.
//  Copyright (c) 2015 Blueprint. All rights reserved.
//

#import "WPEditMiniSiteViewController.h"
#import "WPNetworkingManager.h"

@implementation WPEditMiniSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Edit MiniSite";

    [self.imageInputCell.imageInputView setImageWithURL:self.miniSite.imageURLs.firstObject];
    self.imageInputCell.viewImageButton.alpha = 1;
}

// Override
- (void)updateServerWithMiniSite:(WPMiniSite *)miniSite parameters:(NSMutableDictionary *)parameters {
    miniSite.miniSiteId = self.miniSite.miniSiteId;

    __weak __typeof(self)weakSelf = self;
    [[WPNetworkingManager sharedManager] editMiniSiteWithMiniSite:miniSite parameters:parameters success:^(WPMiniSite *miniSite) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.parent = nil;
        [strongSelf dismissSelf];
    }];
}

#pragma mark - Private Methods

- (void)preloadFields {
    self.nameTextField.text = self.miniSite.name;
    self.streetTextField.text = self.miniSite.street;
    self.cityTextField.text = self.miniSite.city;
    self.stateTextField.text = self.miniSite.state;
    self.zipCodeTextField.text = self.miniSite.zipCode.stringValue;
    self.descriptionTextView.text = self.miniSite.info;

}

#pragma mark - Setter Methods

- (void)setMiniSite:(WPMiniSite *)miniSite {
    _miniSite = miniSite;
    [self preloadFields];
}

@end
