//
//  WPEditViewController.m
//  Watershed
//
//  Created by Melissa Huang on 11/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#pragma GCC diagnostic ignored "-Wundeclared-selector"
#import "WPEditViewController.h"
#import "WPEditView.h"
#import "WPUser.h"

@interface WPEditViewController()
@property (nonatomic) WPEditView *view;
@end

@implementation WPEditViewController

- (instancetype)initWithUser:(WPUser *)user {
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad {
    self.navigationController.navigationBar.tintColor = [UIColor wp_blue];
    self.title = @"Edit Profile";

    FAKIonIcons *closeIcon = [FAKIonIcons androidCloseIconWithSize:24];
    UIImage *closeImage = [closeIcon imageWithSize:CGSizeMake(24, 24)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:closeImage style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelf)];
    self.navigationItem.leftBarButtonItem = cancelButton;

    FAKIonIcons *checkIcon = [FAKIonIcons androidDoneIconWithSize:24];
    UIImage *checkImage = [checkIcon imageWithSize:CGSizeMake(24, 24)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithImage:checkImage style:UIBarButtonItemStylePlain target:self action:@selector(saveAndDismissSelf)];
    self.navigationItem.rightBarButtonItem = doneButton;

    [self.view configureWithUser:_user];
}

-(void)loadView {
    self.view = [[WPEditView alloc] init];
}

#pragma mark - Private Methods

-(void)dismissSelf {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)saveAndDismissSelf {
    //save
    [self dismissSelf];
}

@end
