//
//  WPNetworkingManager.h
//  Watershed
//
//  Created by Andrew Millman on 11/16/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPNetworkingManager : NSObject
+ (WPNetworkingManager *)sharedManager;
- (void)requestLoginWithParameters:(NSDictionary *)parameters success:(void (^)(id))success;
@end
