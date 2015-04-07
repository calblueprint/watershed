//
//  WPUser.m
//  Watershed
//
//  Created by Melissa Huang on 10/22/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPUser.h"

@implementation WPUser

- (instancetype)initWithFacebookUser:(id<FBGraphUser>)user {
    self.email = user[@"email"];
    self.name = user[@"name"];
    self.profilePictureId = user[@"id"];
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userId" : @"id",
             @"profilePictureId" : @"facebook_id"
             };
}

@end
