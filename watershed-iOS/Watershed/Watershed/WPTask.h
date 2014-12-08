//
//  WPTask.h
//  Watershed
//
//  Created by Jordeen Chang on 11/22/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPSite.h"
#import "WPUser.h"
#import "Mantle.h"

@interface WPTask : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *taskId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *taskDescription;
@property (nonatomic) NSDate *dueDate;
@property (nonatomic) Boolean *urgent;
@property (nonatomic) NSNumber *siteId;
@property (nonatomic) WPUser *assignee;
@property (nonatomic) WPUser *assigner;
@property (nonatomic) WPSite *site;
@property (nonatomic) Boolean *completed;

@end
