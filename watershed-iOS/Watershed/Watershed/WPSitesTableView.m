//
//  WPSitesTableView.m
//  Watershed
//
//  Created by Andrew Millman on 10/26/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSitesTableView.h"

@implementation WPSitesTableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}

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
