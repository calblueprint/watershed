//
//  WPTask.h
//  Watershed
//
//  Created by Melissa Huang on 12/7/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "Mantle.h"

@interface WPTask : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *taskId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *taskDescription;
@property (nonatomic) NSNumber *miniSiteId;
@property (nonatomic) NSNumber *assignerId;
@property (nonatomic) NSNumber *assigneeId;
@property (assign) BOOL complete;
@property (assign) BOOL urgent;
@property (nonatomic) NSDate *dueDate;

@end
