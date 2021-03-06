//
//  WPTask.h
//  Watershed
//
//  Created by Jordeen Chang on 11/22/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPMiniSite.h"
#import "WPUser.h"
#import "Mantle.h"

@interface WPTask : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *taskId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *taskDescription;
@property (nonatomic) NSString *dueDate;
@property (nonatomic) BOOL urgent;
@property (nonatomic) NSNumber *siteId;
@property (nonatomic) WPUser *assignee;
@property (nonatomic) WPUser *assigner;
@property (nonatomic) WPMiniSite *miniSite;
@property (nonatomic) BOOL completed;

@end
