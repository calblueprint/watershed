//
//  WPSelectVegetationViewController.h
//  Watershed
//
//  Created by Andrew Millman on 12/13/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPViewController.h"

@protocol SelectVegetationDelegate <NSObject>
- (void)vegetationFinishedSelectingFromList:(NSArray *)fullVegetationList
                                vegetations:(NSArray *)vegetations
                                    indices:(NSArray *)indices;
@end

@interface WPSelectVegetationViewController : WPViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) id<SelectVegetationDelegate> delegate;
@property (nonatomic) NSMutableArray *vegetationList;
@property (nonatomic) NSMutableArray *selectedIndices;
@end
