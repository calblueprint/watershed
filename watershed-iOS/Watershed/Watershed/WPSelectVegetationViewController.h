//
//  WPSelectVegetationViewController.h
//  Watershed
//
//  Created by Andrew Millman on 12/13/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPViewController.h"

@protocol SelectVegetationDelegate <NSObject>
- (void)vegetationFinishedSelecting:(NSArray *)vegetation;
@end

@interface WPSelectVegetationViewController : WPViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) id<SelectVegetationDelegate> delegate;
@end
