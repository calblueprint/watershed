//
//  WPCreateMiniSiteViewController.m
//  Watershed
//
//  Created by Andrew Millman on 12/9/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPCreateMiniSiteViewController.h"
#import "WPView.h"

@interface WPCreateMiniSiteViewController ()

@property (nonatomic) UITableView *infoTableView;
@property (nonatomic) NSArray *textInputViews;
@property (nonatomic) BSKeyboardControls *keyboardControls;

@end

@implementation WPCreateMiniSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = @"New Site";
    
    FAKFontAwesome *closeIcon = [FAKFontAwesome closeIconWithSize:22];
    UIImage *closeImage = [closeIcon imageWithSize:CGSizeMake(22, 22)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithImage:closeImage style:UIBarButtonItemStylePlain target:self action:@selector(dismissSelf)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor wp_blue];
    
    FAKFontAwesome *checkIcon = [FAKFontAwesome checkIconWithSize:22];
    UIImage *checkImage = [checkIcon imageWithSize:CGSizeMake(22, 22)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithImage:checkImage style:UIBarButtonItemStylePlain target:self action:@selector(saveAndDismissSelf)];
    self.navigationItem.rightBarButtonItem = doneButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor wp_blue];
    
    //self.keyboardControls.delegate = self;
}

- (void)loadView {
}

- (void)dismissSelf {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveAndDismissSelf {
}

@end
