//
//  WPFieldReport.m
//  Watershed
//
//  Created by Andrew Millman on 11/15/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPFieldReport.h"

@implementation WPFieldReport

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"fieldReportId" : @"id",
             @"info" : @"description",
             @"rating" : @"health_rating"
             };
}

- (NSMutableArray *)imageURLs {
    if (!_imageURLs) {
        _imageURLs = [[NSMutableArray alloc] init];
    }
    return _imageURLs;
}

@end
