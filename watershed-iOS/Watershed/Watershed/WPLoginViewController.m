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
#import "UICKeyChainStore.h"
#import "WPRootViewController.h"

static NSString * const SIGNIN_URL = @"users/sign_in";

@interface WPLoginViewController ()
@property (nonatomic) WPLoginView *view;
@property (nonatomic) WPAppDelegate *appDelegate;
@end

@implementation WPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = [WPAppDelegate instance];
}

- (void)loadView {
    self.view = [[WPLoginView alloc] init];
    [self.view setParentViewController:self];
}

- (void)emailSignup {
    self.view.emailTextField.placeholder = nil;
    self.view.passwordTextField.placeholder = nil;
    
    NSString *email = self.view.emailTextField.text;
    NSString *password = self.view.passwordTextField.text;
    
    AFHTTPRequestOperationManager *manager = _appDelegate.getAFManager;
    NSDictionary *parameters = @{@"user" : @{@"email": email, @"password": password}};
    
    NSString *loginString = [manager.baseURL.absoluteString stringByAppendingString:SIGNIN_URL];
    [manager POST:loginString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self parseResponse:responseObject];
        [self pushTabBarController];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *incorrect = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Incorrect email or password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [incorrect show];
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)parseResponse:(id)responseObject {
    NSDictionary *responseDictionary = responseObject;
    NSString *authToken = [responseDictionary objectForKey:@"authentication_token"];
    //NSString *name = [[responseDictionary objectForKey:@"user"] objectForKey:@"name"];
    
    UICKeyChainStore *store = [_appDelegate getKeyChainStore];
    [store setString:authToken forKey:@"auth_token"];
    [store synchronize];
}

- (void)pushTabBarController {
    WPRootViewController *parentVC = (WPRootViewController *)self.parentViewController;
    [parentVC pushNewTabBarControllerFromLogin:self];
}

@end
