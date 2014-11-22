//
//  WPAddTaskView.m
//  Watershed
//
//  Created by Jordeen Chang on 11/21/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPAddTaskView.h"

@interface WPAddTaskView ()


@end

@implementation WPAddTaskView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame visibleNavbar:YES];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubviews];
        [self updateConstraints];
    }

    self.taskFormTableView.scrollEnabled = NO;
    [self.taskFormTableView reloadData];
    return self;
}

//- (void)configureWithUser {
//    self.user = [[WPUser alloc] init];
//    [self.user setProfilePicture:@"max.png"];
//    [self.user setUserId:[NSNumber numberWithInt:5]];
//    [self.user setName:@"Max Wolffe"];
//    [self.user setPhoneNumber:@"9162128793"];
//    [self.user setEmail:@"max@millman.com"];
//    [self.user setLocation:@"123 Millman Way Berkeley, CA 82918"];
//}

#pragma mark - View Hierarchy


- (void)createSubviews {
    
    _taskFormTableView = [[UITableView alloc] init];
    _taskFormTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_taskFormTableView];
    
}

- (void)updateConstraints {
    
    [self.taskFormTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(50);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [super updateConstraints];
}


@end
