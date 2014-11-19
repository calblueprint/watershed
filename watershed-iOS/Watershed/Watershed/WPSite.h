//
//  WPSite.h
//  Watershed
//
//  Created by Andrew Millman on 11/15/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPSite : NSObject

@property (nonatomic) NSNumber *siteId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *info;
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
@property (nonatomic) NSString *street;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *state;
@property (nonatomic) NSNumber *zipCode;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSMutableArray *miniSites; //of WPMiniSite's
@property (nonatomic) NSInteger miniSitesCount;

@end
