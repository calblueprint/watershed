//
//  WPFieldReportViewController.m
//  Watershed
//
//  Created by Andrew Millman on 11/9/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPFieldReportViewController.h"
#import "WPFieldReportView.h"
#import "WPNetworkingManager.h"

@interface WPFieldReportViewController ()
@property (nonatomic) WPFieldReportView *view;
@end

@implementation WPFieldReportViewController
@synthesize fieldReport = _fieldReport;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [self.fieldReport dateString];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    __weak __typeof(self)weakSelf = self;
    [[WPNetworkingManager sharedManager] requestFieldReportWithFieldReport:self.fieldReport parameters:[[NSMutableDictionary alloc] init] success:^(WPFieldReport *fieldReport) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.fieldReport = fieldReport;
        [strongSelf.view showBubbles];
        [strongSelf setUpActions];
    }];
}

- (void)loadView {
    self.view = [[WPFieldReportView alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self isMovingToParentViewController]) {
        //view controller is being pushed on
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self isMovingFromParentViewController]) {
        //view controller is being popped off
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
}

- (void)setUpActions {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentImageView)];
    [self.view.reportImageView addGestureRecognizer:tap];
}

#pragma mark - Photo Viewing Methods

- (void)presentImageView {
    UIViewController *viewPhotoModal = [[UIViewController alloc] init];
    viewPhotoModal.view.backgroundColor = [UIColor blackColor];
    viewPhotoModal.view.userInteractionEnabled = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:viewPhotoModal.view.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = self.view.reportImageView.image;
    [viewPhotoModal.view addSubview:imageView];
    
    UITapGestureRecognizer *modalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissModalView:)];
    [viewPhotoModal.view addGestureRecognizer:modalTap];
    viewPhotoModal.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:viewPhotoModal animated:YES completion:nil];
}

- (void)dismissModalView:(UIGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Update field report view

- (void)updateFieldReportView {
    UIColor *ratingColor = [UIColor colorForRating:[self.fieldReport.rating intValue]];
    self.view.backgroundColor = ratingColor;
    self.view.ratingNumberLabel.text = [self.fieldReport.rating stringValue];
    self.view.ratingNumberLabel.textColor = ratingColor;
    self.view.ratingNumberLabel.layer.borderColor = [ratingColor CGColor];
    [self.view.reportImageView setImageWithURL:[self.fieldReport.imageURLs firstObject]
                              placeholderImage:[UIImage imageNamed:@"WPBlue"]];
    self.view.userImageView.image = [UIImage imageNamed:@"max"];
    self.view.userImageView.layer.borderColor = [ratingColor CGColor];
    self.view.titleLabel.text = self.fieldReport.miniSite.name;
    self.view.userLabel.text = @"Reported by Max Wolfe";
    self.view.descriptionLabel.text = self.fieldReport.info;
}

#pragma mark - Setter Methods

- (void)setFieldReport:(WPFieldReport *)fieldReport {
    _fieldReport = fieldReport;
    [self updateFieldReportView];
}

#pragma mark - Lazy Instantiation

- (WPFieldReport *)fieldReport {
    if (!_fieldReport) {
        _fieldReport = [[WPFieldReport alloc] init];
    }
    return _fieldReport;
}

@end
