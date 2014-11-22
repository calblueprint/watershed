//
//  WPFieldReport.h
//  Watershed
//
//  Created by Andrew Millman on 11/15/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPUser.h"
#import "WPMiniSite.h"

@interface WPFieldReport : NSObject

@property (nonatomic) NSNumber *fieldReportId;
@property (nonatomic) NSString *creationDate;
@property (nonatomic) NSString *info;
@property (nonatomic) NSInteger rating;
@property (nonatomic) BOOL urgent;
@property (nonatomic) WPUser *user;
@property (nonatomic) WPMiniSite *miniSite;

@end