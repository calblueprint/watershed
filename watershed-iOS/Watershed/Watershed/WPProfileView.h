//
//  WPProfileView.h
//  Watershed
//
//  Created by Melissa Huang on 10/14/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPView.h"
#import "WPUser.h"

@interface WPProfileView : WPView <UITableViewDataSource, UITableViewDelegate>

- (void)configureWithUser:(WPUser *)user;

@end
