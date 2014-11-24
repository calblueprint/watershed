//
//  WPSelectMiniSiteViewController.h
//  Watershed
//
//  Created by Jordeen Chang on 11/24/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPViewController.h"

@protocol SelectTaskDelegate <NSObject>
-(void) secondViewControllerDismissed:(NSString *)stringForFirst;
@end

@interface WPSelectMiniSiteViewController : WPViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<SelectTaskDelegate>    selectTaskDelegate;
@property (nonatomic) NSString *myString;

@end
