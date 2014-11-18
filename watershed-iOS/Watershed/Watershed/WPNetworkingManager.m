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
@property (nonatomic) WPAppDelegate *appDelegate;
@end

@implementation WPNetworkingManager

static NSString * const BASE_URL = @"https://intense-reaches-1457.herokuapp.com/api/v1/";
static NSString * const SIGNIN_URL = @"users/sign_in";

#pragma mark - Singleton Methods

+ (WPNetworkingManager *)sharedManager {
    static WPNetworkingManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseURL = [[NSURL alloc] initWithString:BASE_URL];
        sharedManager = [[self alloc] initWithBaseURL:baseURL];
        sharedManager.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    return sharedManager;
}

#pragma mark - HTTP Request Methods

- (void)requestLoginWithParameters:(NSDictionary *)parameters success:(void (^)(id response))success {
    NSString *signInString = [WPNetworkingManager createURLWithEndpoint:SIGNIN_URL];
    
    [self POST:signInString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Incorrect email or password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [incorrect show];
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - URL Creation

+ (NSString *)createURLWithEndpoint:(NSString *)endpoint {
    return [BASE_URL stringByAppendingString:endpoint];
}

#pragma mark - Lazy Instantiation

- (WPAppDelegate *)appDelegate {
    if (!_appDelegate) {
        _appDelegate = [WPAppDelegate instance];
    }
    return _appDelegate;
}

- (UICKeyChainStore *)keyChainStore {
    if (!_keyChainStore) {
        _keyChainStore = [UICKeyChainStore keyChainStore];
    }
    return _keyChainStore;
}

@end
