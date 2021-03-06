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

@property (nonatomic) UIView *navbarShadowOverlay;
@property (nonatomic) UITableView *infoTableView;
@property (nonatomic) UIView *profilePicView;
@property (nonatomic) UIView *statusBarView;
@property (nonatomic) WPUser *user;

@end

@implementation WPEditView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createSubviews {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    _infoTableView = [({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.scrollEnabled = NO;
        tableView;
    }) wp_addToSuperview:self];
    
    _statusBarView = [({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view;
    }) wp_addToSuperview:self];

    _navbarShadowOverlay = [({
        UIImageView *navbarShadowOverlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShadowOverlay"]];
        [navbarShadowOverlay setContentMode:UIViewContentModeScaleToFill];
        [navbarShadowOverlay setClipsToBounds:YES];
        navbarShadowOverlay.alpha = 0.10;
        navbarShadowOverlay;
    }) wp_addToSuperview:self];
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
    
    [self.navbarShadowOverlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.equalTo(@10);
    }];

    [super updateConstraints];
}

- (void)configureWithUser:(WPUser *)user {
    self.user = user;
    [self createSubviews];
    [self setNeedsUpdateConstraints];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPEditTableViewCell *newCell = [[WPEditTableViewCell alloc] init];
    switch (indexPath.row) {
        case 0: {
            newCell.textLabel.text = @"Name";
            UITextField *editName = [[UITextField alloc] init];
            editName.text = self.user.name;
            newCell.editField = editName;
            break;
        }
        case 1: {
            newCell.textLabel.text = @"Email";
            UITextField *editEmail = [[UITextField alloc] init];
            editEmail.text = self.user.email;
            newCell.editField = editEmail;
            break;
        }
        case 2: {
            newCell.textLabel.text = @"Address";
            UITextField *editAddress = [[UITextField alloc] init];
            //
            newCell.editField = editAddress;
            break;
        }
        case 3: {
            newCell.textLabel.text = @"Phone Number";
            UITextField *editPhone = [[UITextField alloc] init];
            //
            newCell.editField = editPhone;
            break;
        }
        case 4: {
            newCell.textLabel.text = @"Profile Picture";
            break;
        }
        default: {
            //do nothing
        }
    }
    [newCell addEditField];
    return newCell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
@end

@implementation WPEditTableViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)addEditField {
    [self.contentView addSubview:self.editField];
    
}

- (void)updateConstraints {
    
    [self.editField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-standardMargin));
        make.centerY.equalTo(self.mas_centerY);
    }];

    [super updateConstraints];
}

@end
