//
//  WPEditView.h
//  Watershed
//
//  Created by Melissa Huang on 11/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPView.h"

@interface WPEditView : WPView <UITableViewDelegate, UITableViewDataSource>

@end

@interface WPEditTableViewCell : UITableViewCell

@property (nonatomic) UITextField *editField;
- (void)addSubviews;

@end