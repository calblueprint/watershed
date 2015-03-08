//
//  WPTask.m
//  Watershed
//
//  Created by Jordeen Chang on 11/22/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTask.h"
#import "WPUser.h"
#import "WPSite.h"

@implementation WPTask

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"taskId" : @"id",
             @"taskDescription" : @"description",
             @"completed" : @"complete",
             @"dueDate" : @"due_date"
             };
}

- (NSString *)description {
    return @"Task";
}

+ (NSValueTransformer *)booleanJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)assigneeJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[WPUser class]];
}

+ (NSValueTransformer *)assignerJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[WPUser class]];
}

+ (NSValueTransformer *)siteJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[WPSite class]];
}
//           what to do with these objects?
//             @"assignee_id",
//             site_id
//             assigner_id: integer


@end
