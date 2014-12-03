//
//  LoginViewController.m
//  Watershed
//
//  Created by Andrew Millman on 9/28/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPLoginViewController.h"
#import "WPLoginView.h"
#import "WPNetworkingManager.h"
#import "AFNetworking.h"
#import "WPAppDelegate.h"
#import "UICKeyChainStore.h"
#import "WPRootViewController.h"
#import "WPUser.h"
#import "WPSignupViewController.h"


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
    
    NSDictionary *parameters = @{@"user" : @{@"email": email, @"password": password}};
    
    [[WPNetworkingManager sharedManager] requestLoginWithParameters:parameters success:^(WPUser *user) {
        [self pushTabBarController];
    }];
}

- (void)pushTabBarController {
    WPRootViewController *parentVC = (WPRootViewController *)self.parentViewController;
    [parentVC pushNewTabBarControllerFromLogin:self];
}

#pragma mark - Signup

- (void)presentSignupViewController {
    WPSignupViewController *signupViewController = [[WPSignupViewController alloc] init];
    UINavigationController *signupNavController = [[UINavigationController alloc] initWithRootViewController:signupViewController];
//    [signupViewController.navigationController.navigationBar setBackgroundColor:[UIColor wp_transWhite]];
//    [editNavController.navigationBar setBarTintColor:[UIColor whiteColor]];
//    [editNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    signupViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSignup)];
    [self presentViewController:signupNavController animated:YES completion:nil];
}

- (void)cancelSignup {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    WPUser *fbUser = [[WPUser alloc] initWithFacebookUser:user];
    NSString *fbAccessToken = [FBSession activeSession].accessTokenData.accessToken;
  
    // NOTE(mark): Using the same networking setup as before, change this when you get your network manager in place.
    NSDictionary *parameters = @{@"user" : @{
                                     @"email": fbUser.email,
                                     @"facebook_auth_token": fbAccessToken,
                                     @"name": fbUser.name,
                                     @"facebook_id": fbUser.profilePictureId,
                                     }};
    
    [[WPNetworkingManager sharedManager] requestFacebookLoginWithParameters:parameters success:^(WPUser *user) {
        [self pushTabBarController];
    }];
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    //do something with logged in user
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
