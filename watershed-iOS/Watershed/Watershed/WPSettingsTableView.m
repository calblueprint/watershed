//
//  WPSettingsTableView.m
//  Watershed
//
//  Created by Andrew on 11/1/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSettingsTableView.h"

@implementation WPSettingsTableView

- (void)updateConstraints {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@64);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [super updateConstraints];
}

@end
