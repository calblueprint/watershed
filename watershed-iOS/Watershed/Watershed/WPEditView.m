//
//  WPEditView.m
//  Watershed
//
//  Created by Melissa Huang on 11/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPEditView.h"
#import "UIExtensions.h"

@interface WPEditView ()

@property (nonatomic) UITableView *infoTableView;
@property (nonatomic) UIView *profilePicView;

@end

@implementation WPEditView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubviews];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)createSubviews {
    _infoTableView = [[UITableView alloc] init];
}

- (void)updateConstraints {
    
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [super updateConstraints];
}
@end
