//
//  WPSelectVegetationViewController.h
//  Watershed
//
//  Created by Andrew Millman on 12/13/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPViewController.h"

@protocol SelectVegetationDelegate <NSObject>
- (void)vegetationFinishedSelecting:(NSArray *)vegetations withIndices:(NSArray *)indices;
@end

@interface WPSelectVegetationViewController : WPViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) id<SelectVegetationDelegate> delegate;
@property (nonatomic) NSArray *selectedIndices;
@end