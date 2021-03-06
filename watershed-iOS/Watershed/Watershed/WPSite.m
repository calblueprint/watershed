//
//  WPSite.m
//  Watershed
//
//  Created by Andrew Millman on 11/15/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSite.h"

@implementation WPSite

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"siteId" : @"id",
             @"info" : @"description",
             @"zipCode" : @"zip_code",
             @"miniSitesCount" : @"mini_sites_count"
             };
}

- (NSString *)description {
    return @"Site";
}

- (NSMutableArray *)imageURLs {
    if (!_imageURLs) {
        _imageURLs = [[NSMutableArray alloc] init];
    }
    return _imageURLs;
}

- (NSMutableArray *)miniSites {
    if (!_miniSites) {
        _miniSites = [[NSMutableArray alloc] init];
    }
    return _miniSites;
}

@end
