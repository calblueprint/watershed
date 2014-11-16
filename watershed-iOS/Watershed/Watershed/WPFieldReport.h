//
//  WPFieldReport.h
//  Watershed
//
//  Created by Andrew Millman on 11/15/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPFieldReport : NSObject

@property (nonatomic) NSString *creationDate;
@property (nonatomic) NSString *info;
@property (nonatomic) NSInteger rating;
@property (nonatomic) BOOL urgent;

@end