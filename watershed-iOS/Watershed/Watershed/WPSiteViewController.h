//
//  WPSiteViewController.h
//  Watershed
//
//  Created by Andrew Millman on 10/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPViewController.h"
#import "WPSite.h"

@interface WPSiteViewController : WPViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) WPSite *site;
- (void)requestAndLoadSite;
@end
