//
//  WPSignupViewController.h
//  Watershed
//
//  Created by Melissa Huang on 12/2/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPViewController.h"
#import "WPView.h"

@interface WPSignupViewController : WPViewController

@end

@interface WPSignupView : WPView

@property (nonatomic) UITextField *nameField;
@property (nonatomic) UITextField *emailField;
@property (nonatomic) UITextField *passwordField;
@property (nonatomic) UITextField *passwordConfirmationField;

@end