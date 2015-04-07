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
#import "Mantle.h"

@interface WPFieldReport : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *fieldReportId;
@property (nonatomic) NSDate *creationDate;
@property (nonatomic) NSString *info;
@property (nonatomic) NSNumber *rating;
@property (nonatomic) NSNumber *urgent;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSMutableArray *imageURLs; //of NSURL's
@property (nonatomic) WPUser *user;
@property (nonatomic) WPMiniSite *miniSite;

- (NSString *)dateString;
@end