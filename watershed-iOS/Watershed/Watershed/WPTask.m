//
//  WPTask.m
//  Watershed
//
//  Created by Melissa Huang on 12/7/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTask.h"

@implementation WPTask

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"taskId" : @"id",
             @"taskDescription" : @"description",
             };
}

@end
