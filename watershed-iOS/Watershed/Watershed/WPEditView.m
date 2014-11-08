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
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createSubviews {
    _infoTableView = [[UITableView alloc] init];
    _infoTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    [self addSubview:_infoTableView];
}

- (void)updateConstraints {
     
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
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
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *newCell = [[UITableViewCell alloc] init];

    return newCell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}
@end
