//
//  WPSelectMiniSiteViewController.h
//  Watershed
//
//  Created by Jordeen Chang on 11/24/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPViewController.h"
#import "WPSite.h"

@protocol SelectSiteDelegate <NSObject>
-(void) selectSiteViewControllerDismissed:(WPSite *)selectedSite;
@end

@interface WPSelectMiniSiteViewController : WPViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<SelectSiteDelegate> selectSiteDelegate;
@property (nonatomic) NSString *myString;

@end
