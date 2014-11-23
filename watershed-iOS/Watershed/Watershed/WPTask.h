//
//  WPTask.h
//  Watershed
//
//  Created by Jordeen Chang on 11/22/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPTask : NSObject

@property (nonatomic) NSNumber *taskId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *taskDescription;
@property (nonatomic) NSDate *dueDate;
@property (nonatomic) Boolean *urgent;
@property (nonatomic) Boolean *completed;
@property (nonatomic) NSNumber *siteId;
@property (nonatomic) NSNumber *assigneeId;
@property (nonatomic) NSNumber *assignerId;

@end
