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
static NSString * const FACEBOOK_LOGIN_URL = @"users/sign_up/facebook";
static NSString * const SITES_URL = @"sites";
static NSString * const MINI_SITES_URL = @"mini_sites";

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

- (void)requestLoginWithParameters:(NSDictionary *)parameters success:(void (^)(WPUser *user))success {
    NSString *signInString = [WPNetworkingManager createURLWithEndpoint:SIGNIN_URL];
    
    [self POST:signInString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SIGN IN RESPONSE: %@", responseObject);
        
        NSDictionary *responseDictionary = responseObject;
        NSString *authToken = responseDictionary[@"authentication_token"];
        NSString *email = responseDictionary[@"email"];
        [self updateLoginKeyChainInfoWithAuthToken:authToken email:email];
        
        NSDictionary *userJSON = responseDictionary[@"user"];
        WPUser *user = [MTLJSONAdapter modelOfClass:WPUser.class fromJSONDictionary:userJSON error:nil];
        success(user);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Incorrect email or password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [incorrect show];
        NSLog(@"Error: %@", error);
    }];
}

- (void)requestFacebookLoginWithParameters:(NSDictionary *)parameters success:(void (^)(WPUser *user))success {
    NSString *facebookLoginString = [WPNetworkingManager createURLWithEndpoint:FACEBOOK_LOGIN_URL];
    
    [self POST:facebookLoginString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"FACEBOOK LOGIN RESPONSE: %@", responseObject);
        
        NSDictionary *responseDictionary = responseObject;
        NSString *authToken = responseDictionary[@"authentication_token"];
        NSString *email = responseDictionary[@"email"];
        [self updateLoginKeyChainInfoWithAuthToken:authToken email:email];
        
        NSDictionary *userJSON = responseDictionary[@"user"];
        WPUser *user = [MTLJSONAdapter modelOfClass:WPUser.class fromJSONDictionary:userJSON error:nil];
        success(user);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot log in with Facebook." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [incorrect show];
        NSLog(@"Error: %@", error);
    }];
}

- (void)requestSitesListWithParameters:(NSMutableDictionary *)parameters success:(void (^)(NSMutableArray *sitesList))success {
    NSString *sitesString = [WPNetworkingManager createURLWithEndpoint:SITES_URL];
    [self addAuthenticationParameters:parameters];
    
    [self GET:sitesString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SITES LIST: %@", responseObject);
        
        NSArray *sitesListJSON = (NSArray *)responseObject[@"sites"];
        NSMutableArray *sitesList = [[NSMutableArray alloc] init];
        for (NSDictionary *siteJSON in sitesListJSON) {
            WPSite *site = [MTLJSONAdapter modelOfClass:WPSite.class fromJSONDictionary:siteJSON error:nil];
            site.image = [UIImage imageNamed:@"SampleCoverPhoto"];
            [sitesList addObject:site];
        }
        success(sitesList);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not load sites." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [incorrect show];
        NSLog(@"Error: %@", error);
    }];
}

- (void)requestSiteWithSite:(WPSite *)site parameters:(NSMutableDictionary *)parameters success:(void (^)(WPSite *site, NSMutableArray *miniSiteList))success {
    NSString *siteEndpoint = [@"/" stringByAppendingString:[site.siteId stringValue]];
    NSString *SITE_URL = [SITES_URL stringByAppendingString:siteEndpoint];
    NSString *siteString = [WPNetworkingManager createURLWithEndpoint:SITE_URL];
    [self addAuthenticationParameters:parameters];
    
    [self GET:siteString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SINGLE SITE: %@", responseObject);
        
        NSDictionary *siteJSON = (NSDictionary *)responseObject[@"site"];
        WPSite *site = [MTLJSONAdapter modelOfClass:WPSite.class fromJSONDictionary:siteJSON error:nil];
        site.image = [UIImage imageNamed:@"SampleCoverPhoto"];
        
        NSDictionary *miniSiteListJSON = siteJSON[@"mini_sites"];
        NSMutableArray *miniSiteList = [[NSMutableArray alloc] init];
        for (NSDictionary *miniSiteJSON in miniSiteListJSON) {
            WPMiniSite *miniSite = [MTLJSONAdapter modelOfClass:WPMiniSite.class fromJSONDictionary:miniSiteJSON error:nil];
            miniSite.image = [UIImage imageNamed:@"SampleCoverPhoto2"];
            [miniSiteList addObject:miniSite];
        }

        success(site, miniSiteList);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not load site." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [incorrect show];
        NSLog(@"Error: %@", error);
    }];
}

- (void)requestMiniSiteWithMiniSite:(WPMiniSite *)miniSite parameters:(NSMutableDictionary *)parameters success:(void (^)(WPMiniSite *miniSite, NSMutableArray *fieldReportList))success {
    NSString *miniSiteEndpoint = [@"/" stringByAppendingString:[miniSite.miniSiteId stringValue]];
    NSString *MINI_SITE_URL = [MINI_SITES_URL stringByAppendingString:miniSiteEndpoint];
    NSString *miniSiteString = [WPNetworkingManager createURLWithEndpoint:MINI_SITE_URL];
    [self addAuthenticationParameters:parameters];
    
    [self GET:miniSiteString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SINGLE MINI SITE: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not load mini site." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [incorrect show];
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - URL Creation

+ (NSString *)createURLWithEndpoint:(NSString *)endpoint {
    return [BASE_URL stringByAppendingString:endpoint];
}

#pragma mark - Authentication Params

- (void)addAuthenticationParameters:(NSMutableDictionary *)parameters {
    parameters[@"auth_token"] = self.keyChainStore[@"auth_token"];
    parameters[@"email"] = self.keyChainStore[@"email"];
}

#pragma mark - KeyChainStore Configuration

- (void)updateLoginKeyChainInfoWithAuthToken:(NSString *)authToken
                                       email:(NSString *)email {
    [self.keyChainStore setString:authToken forKey:@"auth_token"];
    [self.keyChainStore setString:email forKey:@"email"];
    [self.keyChainStore synchronize];
}

- (void)eraseLoginKeyChainInfo {
    [self.keyChainStore removeItemForKey:@"auth_token"];
    [self.keyChainStore removeItemForKey:@"email"];
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
