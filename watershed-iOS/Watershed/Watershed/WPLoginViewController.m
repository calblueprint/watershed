//
//  LoginViewController.m
//  Watershed
//
//  Created by Andrew Millman on 9/28/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPLoginViewController.h"
#import "WPLoginView.h"
#import "AFNetworking.h"
#import "WPAppDelegate.h"

static NSString * const SIGNIN_URL = @"users/sign_in";

@interface WPLoginViewController ()
@property (nonatomic) WPLoginView *view;
@end

@implementation WPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadView {
    self.view = [[WPLoginView alloc] init];
    [self.view setParentViewController:self];
}

- (void)emailSignup {
    NSString *email = self.view.emailTextField.text;
    NSString *password = self.view.passwordTextField.text;
    
    WPAppDelegate *appDelegate = [WPAppDelegate instance];
    AFHTTPRequestOperationManager *manager = appDelegate.getAFManager;
    NSDictionary *parameters = @{@"user" : @{@"email": email, @"password": password}};
    
    NSString *loginString = [manager.baseURL.absoluteString stringByAppendingString:SIGNIN_URL];
    [manager POST:loginString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self parseResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)parseResponse:(id)responseObject {
    NSDictionary *responseDictionary = responseObject;
    NSString *authToken = [responseDictionary objectForKey:@"authentication_token"];
    NSString *name = [[responseDictionary objectForKey:@"user"] objectForKey:@"name"];
}

@end
