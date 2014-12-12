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
             @"siteId" : @"site_id",
             @"taskCount" : @"tasks_count",
             @"healthRating" : @"health_rating",
             @"fieldReportCount" : @"field_reports_count"
             };
}

- (NSNumber *)siteId {
    return self.site.siteId;
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
