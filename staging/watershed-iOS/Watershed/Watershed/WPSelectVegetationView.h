//
//  WPSelectVegetationView.h
//  Watershed
//
//  Created by Andrew Millman on 12/13/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPView.h"
#import "WPAddVegetationTextField.h"

@interface WPSelectVegetationView : WPView
@property (nonatomic) WPAddVegetationTextField *addVegetationTextField;
@property (nonatomic) UITableView *selectVegetationTableView;
@end
