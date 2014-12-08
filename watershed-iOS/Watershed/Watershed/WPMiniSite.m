//
//  WPMiniSite.m
//  Watershed
//
//  Created by Andrew Millman on 11/15/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPMiniSite.h"

@implementation WPMiniSite

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"miniSiteId" : @"id",
             @"info" : @"description",
             @"zipCode" : @"zip_code",
             @"taskCount" : @"tasks_count",
             @"fieldReportCount" : @"field_reports_count"
             };
}


- (NSMutableArray *)imageURLs {
    if (!_imageURLs) {
        _imageURLs = [[NSMutableArray alloc] init];
    }
    return _imageURLs;
}

- (NSMutableArray *)fieldReports {
    if (!_fieldReports) {
        _fieldReports = [[NSMutableArray alloc] init];
    }
    return _fieldReports;
}

@end
