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
             @"zipCode" : @"zip_code"
             };
}

@end
