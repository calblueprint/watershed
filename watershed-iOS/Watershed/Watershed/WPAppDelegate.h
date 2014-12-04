//
//  WPAppDelegate.h
//  Watershed
//
//  Created by Melissa Huang on 9/15/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface WPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL shouldSendPush;

+ (WPAppDelegate *)instance;

@end
    