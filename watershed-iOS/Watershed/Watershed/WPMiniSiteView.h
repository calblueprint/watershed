//
//  WPMiniSiteView.h
//  Watershed
//
//  Created by Andrew Millman on 11/2/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPView.h"

@interface WPMiniSiteView : WPView

@property (nonatomic) UITableView *fieldReportTableView;
- (void)updateTableViewHeight:(NSInteger)cellCount;


@end
