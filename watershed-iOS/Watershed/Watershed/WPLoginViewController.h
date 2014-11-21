//
//  LoginViewController.h
//  Watershed
//
//  Created by Andrew Millman on 9/28/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Facebook-iOS-SDK/FacebookSDK/FBLoginView.h>

@interface WPLoginViewController : UIViewController <FBLoginViewDelegate>

- (void)emailSignup;

@end
