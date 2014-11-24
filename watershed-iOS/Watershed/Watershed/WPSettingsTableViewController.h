//
//  WPSettingsTableViewController.h
//  Watershed
//
//  Created by Melissa Huang on 10/29/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPViewController.h"
#import "WPUser.h"

@interface WPSettingsTableViewController : WPViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) WPUser *user;

@end
