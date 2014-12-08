//
//  WPCreateSiteViewController.h
//  Watershed
//
//  Created by Andrew Millman on 12/2/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPViewController.h"
#import "WPSitesTableViewController.h"
#import "BSKeyboardControls.h"

@interface WPCreateSiteViewController : WPViewController <UITableViewDelegate, UITableViewDataSource, BSKeyboardControlsDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic) WPSitesTableViewController *parent;
@property (nonatomic) UITextField *nameTextField;
@property (nonatomic) UITextField *streetTextField;
@property (nonatomic) UITextField *cityTextField;
@property (nonatomic) UITextField *stateTextField;
@property (nonatomic) UITextField *zipCodeTextField;
@property (nonatomic) UITextView *descriptionTextView;

@end
