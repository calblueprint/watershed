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
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = @"Edit Profile";
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self.delegate action:@selector(saveAndDismissEdit)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self.delegate action:@selector(dismissEdit)];
    self.navigationItem.rightBarButtonItem = dismissButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor wp_lightGreen];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [self.view configureWithUser:_user];
}

-(void)loadView {
    self.view = [[WPEditView alloc] init];
}

@end
