//
//  LoginViewController.h
//  Watershed
//
//  Created by Andrew Millman on 9/28/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface WPLoginViewController : UIViewController <FBLoginViewDelegate>

- (void)emailSignup;
- (void)presentSignupViewController;

@end
