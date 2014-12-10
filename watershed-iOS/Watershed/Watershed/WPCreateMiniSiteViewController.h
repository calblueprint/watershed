//
//  WPCreateMiniSiteViewController.h
//  Watershed
//
//  Created by Andrew Millman on 12/9/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPViewController.h"
#import "WPMiniSiteViewController.h"
#import "BSKeyboardControls.h"

@interface WPCreateMiniSiteViewController : WPViewController <UITableViewDelegate, UITableViewDataSource, BSKeyboardControlsDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic) WPMiniSiteViewController *parent;
@property (nonatomic) UITextField *nameTextField;
@property (nonatomic) UITextField *streetTextField;
@property (nonatomic) UITextField *cityTextField;
@property (nonatomic) UITextField *stateTextField;
@property (nonatomic) UITextField *zipCodeTextField;
@property (nonatomic) UITextView *descriptionTextView;

@end