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
             @"zipCode" : @"zip_code"
             };
}

@end
