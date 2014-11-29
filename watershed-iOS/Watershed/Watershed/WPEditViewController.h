//
//  WPEditViewController.h
//  Watershed
//
//  Created by Melissa Huang on 11/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPUser.h"
#import "WPSettingsTableViewController.h"

@interface WPEditViewController : UIViewController

- (instancetype)initWithUser:(WPUser *)user;
@property (nonatomic) WPUser *user;
@property (nonatomic) WPSettingsTableViewController *delegate;

@end
