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
@property (nonatomic) UIView *statusBarView;

@end

@implementation WPEditView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubviews];
        [self setNeedsUpdateConstraints];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createSubviews {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    _infoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _infoTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    [self addSubview:_infoTableView];
    
    _statusBarView = [[UIView alloc] init];
    _statusBarView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_statusBarView];
}

- (void)updateConstraints {
     
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.statusBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.equalTo(@20);
    }];
    
    [super updateConstraints];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *newCell = [[UITableViewCell alloc] init];
    switch (indexPath.row) {
        case 0: {
            newCell.textLabel.text = @"Name";
            break;
        }
        case 1: {
            newCell.textLabel.text = @"Email";
            break;
        }
        case 2: {
            newCell.textLabel.text = @"Address";
            break;
        }
        case 3: {
            newCell.textLabel.text = @"Phone Number";
            break;
        }
        default: {
            //do nothing
        }
    }
    return newCell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}
@end
