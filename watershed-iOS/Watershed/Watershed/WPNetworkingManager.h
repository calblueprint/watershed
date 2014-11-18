//
//  WPNetworkingManager.h
//  Watershed
//
//  Created by Andrew Millman on 11/16/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UICKeyChainStore.h"

@interface WPNetworkingManager : NSObject

@property (nonatomic) UICKeyChainStore *keyChainStore;

+ (WPNetworkingManager *)sharedManager;
- (void)requestLoginWithParameters:(NSDictionary *)parameters success:(void (^)(id))success;

@end
