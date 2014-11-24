//
//  WPSelectTaskViewController.h
//  Watershed
//
//  Created by Jordeen Chang on 11/23/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPViewController.h"

@protocol SelectTaskDelegate <NSObject>
-(void) secondViewControllerDismissed:(NSString *)stringForFirst;
@end

@interface WPSelectTaskViewController : WPViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<SelectTaskDelegate>    selectTaskDelegate;
@property (nonatomic) NSString *myString;

@end

