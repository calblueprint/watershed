//
//  WPEditMiniSiteViewController.h
//  Watershed
//
//  Created by Andrew Millman on 2/19/15.
//  Copyright (c) 2015 Blueprint. All rights reserved.
//

#import "WPCreateMiniSiteViewController.h"
#import "WPMiniSite.h"

@interface WPEditMiniSiteViewController : WPCreateMiniSiteViewController
@property (nonatomic) WPMiniSite *miniSite;
@end