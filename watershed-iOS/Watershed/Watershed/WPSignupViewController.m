//
//  WPSignupViewController.m
//  Watershed
//
//  Created by Melissa Huang on 12/2/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSignupViewController.h"

@implementation WPSignupViewController

- (void)viewDidLoad {
    self.navigationItem.title = @"About";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)loadView {
    self.view = [[WPSignupView alloc] init];
}

@end

@implementation WPSignupView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubviews];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)createSubviews {
    

    
}

- (void)updateConstraints {
    

    
    
    [super updateConstraints];
}

@end