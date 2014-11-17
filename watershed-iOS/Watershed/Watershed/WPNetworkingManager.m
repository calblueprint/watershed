//
//  WPNetworkingManager.m
//  Watershed
//
//  Created by Andrew Millman on 11/16/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPNetworkingManager.h"
#import "WPAppDelegate.h"

@interface WPNetworkingManager ()
@property (nonatomic) AFHTTPRequestOperationManager *requestManager;
@property (nonatomic) WPAppDelegate *appDelegate;
@end

@implementation WPNetworkingManager

#pragma mark - Singleton Methods

+ (id)sharedManager {
    static WPNetworkingManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

#pragma mark - Lazy Instantiation

- (AFHTTPRequestOperationManager *)requestManager {
    if (!_requestManager) {
        _requestManager = self.appDelegate.getAFManager;
    }
    return _requestManager;
}

- (WPAppDelegate *)appDelegate {
    if (!_appDelegate) {
        _appDelegate = [WPAppDelegate instance];
    }
    return _appDelegate;
}

@end
