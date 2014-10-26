//
//  WPSiteView.h
//  Watershed
//
//  Created by Andrew on 10/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPView.h"

@interface WPSiteView : WPView

@property (nonatomic) UITableView *miniSiteTableView;
- (void)updateTableViewHeight:(NSInteger)cellCount;

@end
