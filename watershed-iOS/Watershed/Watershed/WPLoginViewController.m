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
#import "WPUser.h"

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
    self.view = [[WPLoginView alloc] initWithParentController:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self.view
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)emailSignup {
    
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

#pragma mark - FBLoginViewDelegate

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    WPUser *fbUser = [[WPUser alloc] initWithFacebookUser:user];
    NSLog(@"%@", @"hey");
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"%@", @"hi");
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
