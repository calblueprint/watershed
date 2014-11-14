//
//  WPRootViewController.h
//  Watershed
//
//  Created by Melissa Huang on 10/1/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPTabBarController.h"

#import "WPLoginViewController.h"

@interface WPRootViewController : UIViewController

- (void)pushNewTabBarController;
- (void)pushNewLoginController;

@end
