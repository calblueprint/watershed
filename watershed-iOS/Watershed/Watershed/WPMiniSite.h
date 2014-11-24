//
//  WPMiniSite.h
//  Watershed
//
//  Created by Andrew Millman on 11/15/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPSite.h"
#import "Mantle.h"

@interface WPMiniSite : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *miniSiteId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *info;
@property (nonatomic) NSNumber *latitude;
@property (nonatomic) NSNumber *longitude;
@property (nonatomic) NSString *street;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *state;
@property (nonatomic) NSNumber *zipCode;
@property (nonatomic) UIImage *image;

@property (nonatomic) WPSite *site;
@property (nonatomic) NSMutableArray *users; //of WPUser's
@property (nonatomic) NSMutableArray *fieldReports;
@property (nonatomic) NSNumber *fieldReportCount;

@end
