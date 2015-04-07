//
//  WPLoginView.h
//  Watershed
//
//  Created by Melissa Huang on 11/12/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPView.h"

@class WPLoginViewController;

@interface WPLoginView : WPView <UITextFieldDelegate>

@property (nonatomic) WPLoginViewController *parentViewController;

@property (nonatomic) UITextField *emailTextField;
@property (nonatomic) UITextField *passwordTextField;

- (instancetype)initWithParentController:(WPLoginViewController *)parentVC;
- (void)dismissKeyboard;

@end
