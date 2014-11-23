//
//  WPUser.h
//  Watershed
//
//  Created by Melissa Huang on 10/22/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Facebook-iOS-SDK/FacebookSDK/FBGraphUser.h>
@interface WPUser : NSObject

@property (nonatomic) NSNumber *userId;
@property (nonatomic) NSString *profilePicture;
@property (nonatomic) NSString *profilePictureId;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *phoneNumber;
@property (nonatomic) NSInteger *role;
@property (nonatomic) NSString *location;

- (instancetype)initWithFacebookUser:(id<FBGraphUser>)user;

@end
