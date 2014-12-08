//
//  WPTask.m
//  Watershed
//
//  Created by Jordeen Chang on 11/22/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTask.h"

@implementation WPTask

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"taskId" : @"id",
             @"taskDescription" : @"description",
             @"completed" : @"complete",
             @"dueDate" : @"due_date",
             };
}

//           what to do with these objects?
//             @"assignee_id",
//             site_id
//             assigner_id: integer


@end
