//
//  WPNetworkingManager.h
//  Watershed
//
//  Created by Andrew Millman on 11/16/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UICKeyChainStore.h"
#import "WPSite.h"

@interface WPNetworkingManager : AFHTTPRequestOperationManager

@property (nonatomic) UICKeyChainStore *keyChainStore;

+ (WPNetworkingManager *)sharedManager;
- (void)requestLoginWithParameters:(NSDictionary *)parameters success:(void (^)(id response))success;
- (void)requestFacebookLoginWithParameters:(NSDictionary *)parameters success:(void (^)(id response))success;
- (void)requestSitesListWithParameters:(NSMutableDictionary *)parameters success:(void (^)(id response))success;
- (void)requestSiteWithSite:(WPSite *)site parameters:(NSMutableDictionary *)parameters success:(void (^)(id response))success;

- (void)eraseStore;
@end
