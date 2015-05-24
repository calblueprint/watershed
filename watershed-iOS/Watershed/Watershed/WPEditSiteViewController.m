//
//  WPEditSiteViewController.m
//  Watershed
//
//  Created by Andrew Millman on 2/17/15.
//  Copyright (c) 2015 Blueprint. All rights reserved.
//

#import "WPEditSiteViewController.h"
#import "WPNetworkingManager.h"
#import "UIExtensions.h"

@implementation WPEditSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Edit Site";

    UIBarButtonItem *cancelButton = self.navigationItem.leftBarButtonItem;

    FAKIonIcons *trashIcon = [FAKIonIcons androidDeleteIconWithSize:24];
    UIImage *trashImage = [trashIcon imageWithSize:CGSizeMake(24, 24)];
    UIBarButtonItem *trashButton = [[UIBarButtonItem alloc] initWithImage:trashImage style:UIBarButtonItemStylePlain target:self action:@selector(confirmDeletion)];
    trashButton.tintColor = [UIColor wp_red];

    [self.navigationItem setLeftBarButtonItems:@[cancelButton, trashButton]];
}

// Override
- (void)updateServerWithSite:(WPSite *)site {
    site.siteId = self.site.siteId;

    // Don't request the list of sites, because it is already called in the ViewController's viewWillAppear
    __weak __typeof(self)weakSelf = self;
    [[WPNetworkingManager sharedManager] editSiteWithSite:site parameters:[[NSMutableDictionary alloc] init] success:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf dismissSelf];
    }];
}

#pragma mark - Private Methods

- (void)confirmDeletion {
    UIAlertView *confirmDelete = [[UIAlertView alloc] initWithTitle:@"Confirm Deletion"
                                                            message:@"Are you sure you want to delete this site?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Yes",nil];
    [confirmDelete show];
}

- (void)deleteSite {
    UIBarButtonItem *deleteItem = self.navigationItem.leftBarButtonItems.lastObject;
    deleteItem.enabled = NO;

    __weak __typeof(self)weakSelf = self;
    [[WPNetworkingManager sharedManager] deleteSiteWithSite:self.site parameters:[[NSMutableDictionary alloc] init] success:^(void) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.delegate.isDismissing = YES;
        [strongSelf dismissSelf];
        [strongSelf.delegate.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)preloadFields {
    self.nameTextField.text = self.site.name;
    self.streetTextField.text = self.site.street;
    self.cityTextField.text = self.site.city;
    self.stateTextField.text = self.site.state;
    self.zipCodeTextField.text = self.site.zipCode.stringValue;
    self.descriptionTextView.text = self.site.info;

}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self deleteSite];
    }
}


#pragma mark - Setter Methods

- (void)setSite:(WPSite *)site {
    _site = site;
    [self preloadFields];
}

@end
