//
//  WPMiniSiteViewController.h
//  Watershed
//
//  Created by Andrew Millman on 11/2/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPViewController.h"
#import "WPMiniSite.h"

@interface WPMiniSiteViewController : WPViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) WPMiniSite *miniSite;
@property (nonatomic) BOOL isDismissing;
- (void)requestAndLoadMiniSite;
@end

