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
#import "WPUser.h"
#import "WPTask.h"
#import "WPSite.h"
#import "WPMiniSite.h"
#import "WPFieldReport.h"

@interface WPNetworkingManager : AFHTTPRequestOperationManager

@property (nonatomic) UICKeyChainStore *keyChainStore;

+ (WPNetworkingManager *)sharedManager;
- (void)requestLoginWithParameters:(NSDictionary *)parameters success:(void (^)(WPUser *user))success;
- (void)requestFacebookLoginWithParameters:(NSDictionary *)parameters success:(void (^)(WPUser *user))success;
- (void)requestTasksListWithParameters:(NSMutableDictionary *)parameters success:(void (^)(NSMutableArray *sitesList))success;
- (void)requestMyTasksListWithUser:(NSNumber *)userId parameters:(NSMutableDictionary *)parameters success:(void (^)(NSMutableArray *tasksList))success;
- (void)requestSitesListWithParameters:(NSMutableDictionary *)parameters success:(void (^)(NSMutableArray *sitesList))success;
- (void)requestSiteWithSite:(WPSite *)site parameters:(NSMutableDictionary *)parameters success:(void (^)(WPSite *site, NSMutableArray *miniSiteList))success;
- (void)requestMiniSiteWithMiniSite:(WPMiniSite *)miniSite parameters:(NSMutableDictionary *)parameters success:(void (^)(WPMiniSite *miniSite, NSMutableArray *fieldReportList))success;
- (void)requestFieldReportWithFieldReport:(WPFieldReport *)fieldReport parameters:(NSMutableDictionary *)parameters success:(void (^)(WPFieldReport *fieldReport))success;
- (void)requestUserWithUser:(WPUser *)user parameters:(NSMutableDictionary *)parameters success:(void (^)(WPUser *user))success;
- (void)postUserWithParameters:(NSDictionary *)parameters success:(void (^)(WPUser *user))success;
- (void)eraseLoginKeyChainInfo;
@end
