//
//  WPProfileView.m
//  Watershed
//
//  Created by Melissa Huang on 10/14/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPProfileView.h"
#import "Masonry.h"
#import "UIColor+WPColors.h"
#import "UIView+WPExtensions.h"
#import "FontAwesomeKit/FontAwesomeKit.h"
#import "WPProfileTableViewCell.h"
#import "WPUser.h"


@interface WPProfileView ()

@property (nonatomic) UITableView *infoTableView;
@property (nonatomic) WPUser *user;
@property (nonatomic) UIImageView *profilePictureView;
@property (nonatomic) UILabel *nameLabel;

@end


@implementation WPProfileView

NSString *profileReuseIdentifier = @"WPProfileCell";
static int PROFILE_PIC_HEIGHT = 65;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame visibleNavbar:YES];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configureWithUser];
        [self createSubviews];
        [self updateConstraints];
    }
    
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    [self.infoTableView reloadData];
    return self;
}

- (void)configureWithUser {
    self.user = [[WPUser alloc] init];
    [self.user setProfilePicture:@"max.png"];
    [self.user setUserId:[NSNumber numberWithInt:5]];
    [self.user setName:@"Max Wolffe"];
    [self.user setPhoneNumber:@"9162128793"];
    [self.user setEmail:@"max@millman.com"];
    [self.user setLocation:@"123 Millman Way Berkeley, CA 82918"];
}

#pragma mark - View Hierarchy

-(void)setRoundedView:(UIImageView *)roundedView {
    CGPoint saveCenter = roundedView.center;
    roundedView.layer.borderWidth = 1.0f;
    roundedView.layer.borderColor = [UIColor blackColor].CGColor;
    roundedView.layer.cornerRadius = PROFILE_PIC_HEIGHT/2;
    roundedView.center = saveCenter;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPProfileTableViewCell *cell = [[WPProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:profileReuseIdentifier];
    switch (indexPath.row) {
        case 1: {
            FAKIonIcons *mailIcon = [FAKIonIcons ios7EmailOutlineIconWithSize:30];
            [cell setIconImageView:[[UIImageView alloc] initWithImage:[mailIcon imageWithSize:CGSizeMake(30, 30)]]];
            
            UILabel *infoLabel = [[UILabel alloc] init];
            infoLabel.text = self.user.email;
            [cell setInfoLabel:infoLabel];
            
            break;
        }
        case 2: {
            FAKIonIcons *locationIcon = [FAKIonIcons ios7LocationOutlineIconWithSize:30];
            [cell setIconImageView:[[UIImageView alloc] initWithImage:[locationIcon imageWithSize:CGSizeMake(30, 30)]]];
            
            UILabel *infoLabel = [[UILabel alloc] init];
            infoLabel.text = self.user.location;
            [cell setInfoLabel:infoLabel];
            break;
        }
        case 3: {
            FAKIonIcons *phoneIcon = [FAKIonIcons ios7TelephoneOutlineIconWithSize:30];
            [cell setIconImageView:[[UIImageView alloc] initWithImage:[phoneIcon imageWithSize:CGSizeMake(30, 30)]]];
            
            UILabel *infoLabel = [[UILabel alloc] init];
            infoLabel.text = self.user.phoneNumber;
            [cell setInfoLabel:infoLabel];
            break;
        }
        default: {
            //do nothing
        }
    }
    cell.infoLabel.textColor = [UIColor darkGrayColor];
    cell.infoLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    [cell addSubviews];
    return cell;
}


- (void)createSubviews {

    _profilePictureView = [[UIImageView alloc] init];
    _profilePictureView.contentMode = UIViewContentModeScaleAspectFit;
    _profilePictureView.clipsToBounds = YES;
    [self setRoundedView:_profilePictureView];
    [_profilePictureView setImage:[UIImage imageNamed:self.user.profilePicture]];
    [self addSubview:_profilePictureView];


    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = self.user.name;
    _nameLabel.textColor = [UIColor blackColor];
    [self addSubview:_nameLabel];
    
    _infoTableView = [[UITableView alloc] init];
    _infoTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_infoTableView];

    
}

- (void)updateConstraints {
    
    [self.profilePictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(64 + 15));
        make.centerX.equalTo(@0);
        make.height.equalTo(@(PROFILE_PIC_HEIGHT));
        make.width.equalTo(@(PROFILE_PIC_HEIGHT));
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profilePictureView.mas_bottom).with.offset(10);
        make.centerX.equalTo(@0);
    }];
    
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(50);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];

    [super updateConstraints];
}

#pragma mark - Table View Protocols

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 1.f;
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


@end
