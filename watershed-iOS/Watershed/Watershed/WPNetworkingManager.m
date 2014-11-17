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

static NSString * const SIGNIN_URL = @"users/sign_in";

#pragma mark - Singleton Methods

+ (WPNetworkingManager *)sharedManager {
    static WPNetworkingManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

#pragma mark - HTTP Request Methods

- (void)requestLoginWithParameters:(NSDictionary *)parameters success:(void (^)(id))success {
    NSString *signInString = [self createURLWithEndpoint:SIGNIN_URL];
    
    [self.requestManager POST:signInString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Incorrect email or password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [incorrect show];
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - URL Creation

- (NSString *)createURLWithEndpoint:(NSString *)endpoint {
    NSString *url = [self.requestManager.baseURL.absoluteString stringByAppendingString:endpoint];
    return url;
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
