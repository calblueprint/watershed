//
//  WPCreateMiniSiteViewController.h
//  Watershed
//
//  Created by Andrew Millman on 12/9/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPViewController.h"
#import "WPSiteViewController.h"
#import "BSKeyboardControls.h"
#import "WPCreateMiniSiteImageTableViewCell.h"

@interface WPCreateMiniSiteViewController : WPViewController <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, BSKeyboardControlsDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic) WPSiteViewController *parent;
@property (nonatomic) UITextField *nameTextField;
@property (nonatomic) UITextField *streetTextField;
@property (nonatomic) UITextField *cityTextField;
@property (nonatomic) UITextField *stateTextField;
@property (nonatomic) UITextField *zipCodeTextField;
@property (nonatomic) UITextView *descriptionTextView;

@property (nonatomic) WPCreateMiniSiteImageTableViewCell *imageInputCell;

@end