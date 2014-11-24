//
//  WPSite.h
//  Watershed
//
//  Created by Andrew Millman on 11/15/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface WPSite : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSNumber *siteId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *info;
@property (nonatomic) NSNumber *latitude;
@property (nonatomic) NSNumber *longitude;
@property (nonatomic) NSString *street;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *state;
@property (nonatomic) NSNumber *zipCode;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSMutableArray *miniSites; //of WPMiniSite's
@property (nonatomic) NSNumber *miniSitesCount;

@end
