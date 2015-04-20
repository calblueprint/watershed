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

static NSString * const BASE_URL = @"https://floating-bayou-8262.herokuapp.com/api/v1/";
static NSString * const SIGNIN_URL = @"users/sign_in";
static NSString * const SIGNUP_URL = @"users";
static NSString * const USERS_URL = @"users";
static NSString * const FACEBOOK_LOGIN_URL = @"users/sign_up/facebook";
static NSString * const SITES_URL = @"sites";
static NSString * const MINI_SITES_URL = @"mini_sites";
static NSString * const FIELD_REPORTS_URL = @"field_reports";
static NSString * const TASKS_URL = @"tasks";

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

- (void)requestTasksListWithParameters:(NSMutableDictionary *)parameters success:(void (^)(NSMutableArray *tasksList))success {

    NSString *tasksString = [WPNetworkingManager createURLWithEndpoint:TASKS_URL];
    [self addAuthenticationParameters:parameters];

    [self GET:tasksString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tasksListJSON = (NSArray *)responseObject[@"tasks"];
        NSMutableArray *tasksList = [[NSMutableArray alloc] init];
        for (NSDictionary *taskJSON in tasksListJSON) {
            WPTask *task = [MTLJSONAdapter modelOfClass:WPTask.class fromJSONDictionary:taskJSON error:nil];
            task.miniSite = [MTLJSONAdapter modelOfClass:WPMiniSite.class fromJSONDictionary:taskJSON[@"mini_site"] error:nil];
            [tasksList addObject:task];
        }
        success(tasksList);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not load tasks." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [incorrect show];
        NSLog(@"Error: %@", error);
    }];
}

- (void)requestMyTasksListWithUser:(NSNumber *)userId parameters:(NSMutableDictionary *)parameters success:(void (^)(NSMutableArray *tasksList))success {
    NSString *myUserString = [NSString stringWithFormat:@"%@/%@/%@",USERS_URL, userId, TASKS_URL];
    NSString *userString = [WPNetworkingManager createURLWithEndpoint:myUserString];

    [self addAuthenticationParameters:parameters];

    [self GET:userString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tasksListJSON = (NSArray *)responseObject[@"tasks"];
        NSMutableArray *tasksList = [[NSMutableArray alloc] init];
        for (NSDictionary *taskJSON in tasksListJSON) {
            WPTask *task = [MTLJSONAdapter modelOfClass:WPTask.class fromJSONDictionary:taskJSON error:nil];
            task.miniSite = [MTLJSONAdapter modelOfClass:WPMiniSite.class fromJSONDictionary:taskJSON[@"mini_site"] error:nil];
            [tasksList addObject:task];
        }
        success(tasksList);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not load user." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [incorrect show];
        NSLog(@"Error: %@", error);
    }];
}

- (void)createTaskWithTask:(WPTask *)task parameters:(NSMutableDictionary *)parameters success:(void (^)())success {
    NSString *taskString = [WPNetworkingManager createURLWithEndpoint:TASKS_URL];
    [self addAuthenticationParameters:parameters];
    NSMutableDictionary *taskJSON = [MTLJSONAdapter JSONDictionaryFromModel:task].mutableCopy;
    NSLog(@"%@", task.assigner.userId);
    [taskJSON setObject:task.assignee.userId forKey:@"assignee_id"];
    [taskJSON setObject:task.assigner.userId forKey:@"assigner_id"];
    [taskJSON setObject:task.miniSite.miniSiteId forKey:@"mini_site_id"];
    [parameters setObject:taskJSON forKey:@"task"];
    [self POST:taskString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not create task." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [incorrect show];
        NSLog(@"Error: %@", error);
    }];
}


- (void)editTaskWithTask:(WPTask *)task parameters:(NSMutableDictionary *)parameters success:(void (^)(WPTask *task))success {
    NSString *taskEndpoint = [@"/" stringByAppendingString:[task.taskId stringValue]];
    NSString *TASK_URL = [TASKS_URL stringByAppendingString:taskEndpoint];
    NSString *taskString = [WPNetworkingManager createURLWithEndpoint:TASK_URL];
    [self addAuthenticationParameters:parameters];
    NSMutableDictionary *taskJSON = [MTLJSONAdapter JSONDictionaryFromModel:task].mutableCopy;
    [parameters setObject:taskJSON forKey:@"task"];

    [self PUT:taskString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not edit task." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [incorrect show];
        NSLog(@"Error: %@", error);
    }];
}

- (void)deleteTaskWithTask:(WPTask *)task parameters:(NSMutableDictionary *)parameters success:(void (^)(WPTask *task))success {
    NSString *taskEndpoint = [@"/" stringByAppendingString:[task.taskId stringValue]];
    NSString *TASK_URL = [TASKS_URL stringByAppendingString:taskEndpoint];
    NSString *taskString = [WPNetworkingManager createURLWithEndpoint:TASK_URL];
    [self addAuthenticationParameters:parameters];
    NSMutableDictionary *taskJSON = [MTLJSONAdapter JSONDictionaryFromModel:task].mutableCopy;
    [taskJSON setObject:task.taskId forKey:@"task_id"];
    [parameters setObject:taskJSON forKey:@"task"];

    [self DELETE:taskString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not delete task." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [incorrect show];
        NSLog(@"Error: %@", error);
    }];

}

- (void)requestSitesListWithParameters:(NSMutableDictionary *)parameters success:(void (^)(NSMutableArray *sitesList))success {
    NSString *sitesString = [WPNetworkingManager createURLWithEndpoint:SITES_URL];
    [self addAuthenticationParameters:parameters];
    parameters[@"get_photos"] = @"true";
    
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
            NSDictionary *photoJSON = fieldReportJSON[@"photo"];
            if (!([photoJSON isEqual:[NSNull null]]) && photoJSON) {
                [fieldReport.imageURLs addObject:[NSURL URLWithString:photoJSON[@"url"]]];
            }
            [fieldReportList addObject:fieldReport];
        }
        miniSiteResponse.fieldReports = fieldReportList;
        success(miniSiteResponse, fieldReportList);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not load mini site." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [incorrect show];
        NSLog(@"Error: %@", error);
    }];
}

- (void)createMiniSiteWithMiniSite:(WPMiniSite *)miniSite parameters:(NSMutableDictionary *)parameters success:(void (^)(WPMiniSite *miniSite))success {
    NSString *miniSiteString = [WPNetworkingManager createURLWithEndpoint:MINI_SITES_URL];
    [self addAuthenticationParameters:parameters];
    NSMutableDictionary *miniSiteJSON = [MTLJSONAdapter JSONDictionaryFromModel:miniSite].mutableCopy;
    [miniSiteJSON setObject:miniSite.site.siteId forKey:@"site_id"];
    
    //Pass photo attributes through parameters and then insert them into the miniSiteJSON
    NSDictionary *photoAttributes = parameters[@"photos_attributes"];
    [parameters removeObjectForKey:@"photos_attributes"];
    [miniSiteJSON setObject:photoAttributes forKey:@"photos_attributes"];
    [parameters setObject:miniSiteJSON forKey:@"mini_site"];
    
    [self POST:miniSiteString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *miniSiteJSON = (NSDictionary *)responseObject[@"mini_site"];
        WPMiniSite *miniSiteResponse = [MTLJSONAdapter modelOfClass:WPMiniSite.class fromJSONDictionary:miniSiteJSON error:nil];
        miniSiteResponse.site = miniSite.site;
        NSArray *photosListJSON = miniSiteJSON[@"photos"];
        for (NSDictionary *photoJSON in photosListJSON) {
            [miniSiteResponse.imageURLs addObject:[NSURL URLWithString:photoJSON[@"url"]]];
        }
        
        success(miniSiteResponse);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not create mini site." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
        fieldReportResponse.imageURLs = fieldReport.imageURLs;
        fieldReportResponse.user = [MTLJSONAdapter modelOfClass:WPUser.class fromJSONDictionary:fieldReportJSON[@"user"] error:nil];
        success(fieldReportResponse);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not load field report." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [incorrect show];
        NSLog(@"Error: %@", error);
    }];
}

- (void)postFieldReportWithParameters:(NSMutableDictionary *)parameters success:(void (^)(WPFieldReport *fieldReport))success {
    NSString *fieldReportString = [WPNetworkingManager createURLWithEndpoint:FIELD_REPORTS_URL];
    [self addAuthenticationParameters:parameters];

    [self POST:fieldReportString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDictionary = responseObject;
        
        WPFieldReport *fieldReport = [MTLJSONAdapter modelOfClass:WPFieldReport.class fromJSONDictionary:responseDictionary error:nil];
        success(fieldReport);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not load field report" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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

- (void)requestUsersListWithParameters:(NSMutableDictionary *)parameters success:(void (^)(NSMutableArray *usersList))success {

    NSString *usersString = [WPNetworkingManager createURLWithEndpoint:USERS_URL];
    [self addAuthenticationParameters:parameters];

    [self GET:usersString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *usersListJSON = (NSArray *)responseObject[@"users"];
        NSMutableArray *usersList = [[NSMutableArray alloc] init];
        for (NSDictionary *userJSON in usersListJSON) {
            WPUser *user = [MTLJSONAdapter modelOfClass:WPUser.class fromJSONDictionary:userJSON error:nil];
//            NSArray *photosListJSON = siteJSON[@"photos"];
//            for (NSDictionary *photoJSON in photosListJSON) {
//                [site.imageURLs addObject:[NSURL URLWithString:photoJSON[@"url"]]];
//            }
            [usersList addObject:user];
        }
        success(usersList);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not load users." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    [self.keyChainStore setString:authToken forKey:@"auth_token"];
    [self.keyChainStore setString:email forKey:@"email"];
    [self.keyChainStore setString:[user.userId stringValue] forKey:@"user_id"];
    [self.keyChainStore setString:[user.role stringValue] forKey:@"role"];
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
