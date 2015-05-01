//
//  WPEditSiteViewController.h
//  Watershed
//
//  Created by Andrew Millman on 2/17/15.
//  Copyright (c) 2015 Blueprint. All rights reserved.
//

#import "WPCreateSiteViewController.h"
#import "WPSiteViewController.h"
#import "WPSite.h"

@interface WPEditSiteViewController : WPCreateSiteViewController
@property (nonatomic) WPSite *site;
@property (nonatomic) WPSiteViewController *delegate;
@end
