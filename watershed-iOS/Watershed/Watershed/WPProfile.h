//
//  WPProfile.h
//  Watershed
//
//  Created by Melissa Huang on 10/22/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPProfile : NSObject

@property NSNumber *userId;
@property NSString *profilePicture;
@property NSString *email;
@property NSString *name;
@property NSString *phoneNumber;
@property NSInteger *role;
@property NSString *location;

@end
