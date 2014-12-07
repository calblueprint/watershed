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
static NSString * const SIGNUP_URL = @"users";
static NSString * const USERS_URL = @"users";
static NSString * const FACEBOOK_LOGIN_URL = @"users/sign_up/facebook";
static NSString * const SITES_URL = @"sites";
static NSString * const MINI_SITES_URL = @"mini_sites";
static NSString * const FIELD_REPORTS_URL = @"field_reports";

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
        NSDictionary *responseDictionary = responseObject;
        NSDictionary *sessionDictionary = [responseDictionary objectForKey:@"session"];
        NSString *authToken = sessionDictionary[@"authentication_token"];
        NSString *email = sessionDictionary[@"email"];

        NSDictionary *userJSON = sessionDictionary[@"user"];
        WPUser *user = [MTLJSONAdapter modelOfClass:WPUser.class fromJSONDictionary:userJSON error:nil];
        [self updateLoginKeyChainInfoWithUser:user AuthToken:authToken email:email];

        success(user);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Incorrect email or password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [incorrect show];
        NSLog(@"Error: %@", error);
    }];
}

- (void)postUserWithParameters:(NSDictionary *)parameters success:(void (^)(WPUser *user))success {
    NSString *signUpString = [WPNetworkingManager createURLWithEndpoint:SIGNUP_URL];
    
    [self POST:signUpString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {        
        NSDictionary *responseDictionary = responseObject;
        NSDictionary *sessionDictionary = [responseDictionary objectForKey:@"session"];
        NSString *authToken = sessionDictionary[@"authentication_token"];
        NSString *email = sessionDictionary[@"email"];
        
        NSDictionary *userJSON = sessionDictionary[@"user"];
        WPUser *user = [MTLJSONAdapter modelOfClass:WPUser.class fromJSONDictionary:userJSON error:nil];
        [self updateLoginKeyChainInfoWithUser:user AuthToken:authToken email:email];
        
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
        NSDictionary *responseDictionary = responseObject;
        NSDictionary *sessionDictionary = [responseDictionary objectForKey:@"session"];
        NSString *authToken = sessionDictionary[@"authentication_token"];
        NSString *email = sessionDictionary[@"email"];
        
        NSDictionary *userJSON = sessionDictionary[@"user"];
        WPUser *user = [MTLJSONAdapter modelOfClass:WPUser.class fromJSONDictionary:userJSON error:nil];
        [self updateLoginKeyChainInfoWithUser:user AuthToken:authToken email:email];
        
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
        NSArray *sitesListJSON = (NSArray *)responseObject[@"sites"];
        NSMutableArray *sitesList = [[NSMutableArray alloc] init];
        for (NSDictionary *siteJSON in sitesListJSON) {
            WPSite *site = [MTLJSONAdapter modelOfClass:WPSite.class fromJSONDictionary:siteJSON error:nil];
            NSArray *photosListJSON = siteJSON[@"photos"];
            for (NSDictionary *photoJSON in photosListJSON) {
                [site.imageURLs addObject:[NSURL URLWithString:photoJSON[@"url"]]];
            }
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
        NSDictionary *siteJSON = (NSDictionary *)responseObject[@"site"];
        WPSite *siteResponse = [MTLJSONAdapter modelOfClass:WPSite.class fromJSONDictionary:siteJSON error:nil];
        NSArray *photosListJSON = siteJSON[@"photos"];
        for (NSDictionary *photoJSON in photosListJSON) {
            [siteResponse.imageURLs addObject:[NSURL URLWithString:photoJSON[@"url"]]];
        }
        
        NSArray *miniSiteListJSON = siteJSON[@"mini_sites"];
        NSMutableArray *miniSiteList = [[NSMutableArray alloc] init];
        for (NSDictionary *miniSiteJSON in miniSiteListJSON) {
            WPMiniSite *miniSite = [MTLJSONAdapter modelOfClass:WPMiniSite.class fromJSONDictionary:miniSiteJSON error:nil];
            NSArray *photosListJSON = miniSiteJSON[@"photos"];
            for (NSDictionary *photoJSON in photosListJSON) {
                [miniSite.imageURLs addObject:[NSURL URLWithString:photoJSON[@"url"]]];
            }
            
            miniSite.site = siteResponse;
            miniSite.fieldReportCount = @(((NSArray *)miniSiteJSON[@"field_reports"]).count);
            [miniSiteList addObject:miniSite];
        }
        siteResponse.miniSites = miniSiteList;
        success(siteResponse, miniSiteList);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not load site." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [incorrect show];
        NSLog(@"Error: %@", error);
    }];
}

- (void)createSiteWithSite:(WPSite *)site parameters:(NSMutableDictionary *)parameters success:(void (^)())success {
    NSString *siteString = [WPNetworkingManager createURLWithEndpoint:SITES_URL];
    [self addAuthenticationParameters:parameters];
    NSDictionary *siteJSON = [MTLJSONAdapter JSONDictionaryFromModel:site];
    [parameters setObject:siteJSON forKey:@"site"];
    
    [self POST:siteString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"CREATED SITE: %@", responseObject);
        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not create site." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
        NSDictionary *miniSiteJSON = (NSDictionary *)responseObject[@"mini_site"];
        WPMiniSite *miniSiteResponse = [MTLJSONAdapter modelOfClass:WPMiniSite.class fromJSONDictionary:miniSiteJSON error:nil];
        miniSiteResponse.site = miniSite.site;
        miniSiteResponse.imageURLs = miniSite.imageURLs;
        
        NSArray *fieldReportListJSON = miniSiteJSON[@"field_reports"];
        NSMutableArray *fieldReportList = [[NSMutableArray alloc] init];
        for (NSDictionary *fieldReportJSON in fieldReportListJSON) {
            WPFieldReport *fieldReport = [MTLJSONAdapter modelOfClass:WPFieldReport.class fromJSONDictionary:fieldReportJSON error:nil];
            fieldReport.miniSite = miniSiteResponse;
            fieldReport.image = [UIImage imageNamed:@"SampleCoverPhoto2"];
            fieldReport.creationDate = @"October 1, 2014";
            [fieldReportList addObject:fieldReport];
        }
        miniSiteResponse.fieldReports = fieldReportList;
        miniSiteResponse.fieldReportCount = @(fieldReportList.count);
        success(miniSiteResponse, fieldReportList);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not load mini site." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [incorrect show];
        NSLog(@"Error: %@", error);
    }];
}

- (void)requestFieldReportWithFieldReport:(WPFieldReport *)fieldReport parameters:(NSMutableDictionary *)parameters success:(void (^)(WPFieldReport *fieldReport))success {
    NSString *fieldReportEndpoint = [@"/" stringByAppendingString:[fieldReport.fieldReportId stringValue]];
    NSString *FIELD_REPORT_URL = [FIELD_REPORTS_URL stringByAppendingString:fieldReportEndpoint];
    NSString *fieldReportString = [WPNetworkingManager createURLWithEndpoint:FIELD_REPORT_URL];
    [self addAuthenticationParameters:parameters];
    
    [self GET:fieldReportString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *fieldReportJSON = (NSDictionary *)responseObject[@"field_report"];
        WPFieldReport *fieldReportResponse = [MTLJSONAdapter modelOfClass:WPFieldReport.class fromJSONDictionary:fieldReportJSON error:nil];
        fieldReportResponse.miniSite = fieldReport.miniSite;
        fieldReportResponse.image = fieldReport.image;
        success(fieldReportResponse);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not load field report." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [incorrect show];
        NSLog(@"Error: %@", error);
    }];
}

- (void)requestUserWithUser:(WPUser *)user parameters:(NSMutableDictionary *)parameters success:(void (^)(WPUser *user))success {
    NSString *userEndpoint = [@"/" stringByAppendingString:[user.userId stringValue]];
    NSString *USER_URL = [USERS_URL stringByAppendingString:userEndpoint];
    NSString *userString = [WPNetworkingManager createURLWithEndpoint:USER_URL];
    [self addAuthenticationParameters:parameters];
    
    [self GET:userString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *userJSON = (NSDictionary *)responseObject[@"user"];
        WPUser *userResponse = [MTLJSONAdapter modelOfClass:WPUser.class fromJSONDictionary:userJSON error:nil];
        success(userResponse);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not load user." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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

- (void)updateLoginKeyChainInfoWithUser:(WPUser *)user
                              AuthToken:(NSString *)authToken
                                  email:(NSString *)email {
    [self.keyChainStore setString:[user.userId stringValue] forKey:@"user_id"];
    [self.keyChainStore setString:[user.role stringValue] forKey:@"role"];
    [self.keyChainStore setString:authToken forKey:@"auth_token"];
    [self.keyChainStore setString:email forKey:@"email"];
    [self.keyChainStore synchronize];
}

- (void)eraseLoginKeyChainInfo {
    [self.keyChainStore removeAllItems];
    [self.keyChainStore synchronize];
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
