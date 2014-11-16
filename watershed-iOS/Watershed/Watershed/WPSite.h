//
//  WPSite.h
//  Watershed
//
//  Created by Andrew on 11/15/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPSite : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *info;
@property (nonatomic) CGPoint *position;
@property (nonatomic) NSString *street;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *state;
@property (nonatomic) NSNumber *zipCode;

@end
