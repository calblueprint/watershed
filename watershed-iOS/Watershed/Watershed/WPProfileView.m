//
//  WPProfileView.m
//  Watershed
//
//  Created by Melissa Huang on 10/14/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPProfileView.h"
#import "UIExtensions.h"
#import "FontAwesomeKit/FontAwesomeKit.h"
#import "WPProfileTableViewCell.h"
#import "WPNetworkingManager.h"

@interface WPProfileView ()

@property (nonatomic) UITableView *infoTableView;
@property (nonatomic) WPUser *user;
@property (nonatomic) UIImageView *profilePictureView;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) NSMutableArray *userInformationArray;

@end


@implementation WPProfileView

NSString *profileReuseIdentifier = @"WPProfileCell";
static int PROFILE_PIC_HEIGHT = 65;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame visibleNavbar:YES];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

    }

    return self;
}

- (void)configureWithUser:(WPUser *)user {
    self.user = user;
    if ([[WPNetworkingManager sharedManager] keyChainStore][@"profilePictureId"]) {
        self.user.profilePictureId = [[WPNetworkingManager sharedManager] keyChainStore][@"profilePictureId"];
    }

    _userInformationArray = [[NSMutableArray alloc] init];
    if (user.email) {
        [_userInformationArray addObject:user.email];
    }
    if (user.location) {
        [_userInformationArray addObject:user.location];
    }
    if (user.phoneNumber) {
        [_userInformationArray addObject:user.phoneNumber];
    }
    [self createSubviews];
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    self.infoTableView.scrollEnabled = NO;
    [self.infoTableView reloadData];
    [self setNeedsUpdateConstraints];
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
            [mailIcon addAttribute:NSForegroundColorAttributeName
                             value:[UIColor darkGrayColor]];
            [cell setIconImageView:[[UIImageView alloc]
                     initWithImage:[mailIcon imageWithSize:CGSizeMake(30, 30)]]];
            
            
            UILabel *infoLabel = [[UILabel alloc] init];
            infoLabel.text = self.user.email;
            [cell setInfoLabel:infoLabel];
            
            break;
        }
        case 2: {
            if (_user.location) {
                FAKIonIcons *locationIcon = [FAKIonIcons ios7LocationOutlineIconWithSize:30];
                [locationIcon addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor darkGrayColor]];
                [cell setIconImageView:[[UIImageView alloc]
                         initWithImage:[locationIcon imageWithSize:CGSizeMake(30, 30)]]];
                
                UILabel *infoLabel = [[UILabel alloc] init];
                infoLabel.text = self.user.location;
                [cell setInfoLabel:infoLabel];
            } else {
                FAKIonIcons *phoneIcon = [FAKIonIcons ios7TelephoneOutlineIconWithSize:30];
                [phoneIcon addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor darkGrayColor]];
                [cell setIconImageView:[[UIImageView alloc]
                                        initWithImage:[phoneIcon imageWithSize:CGSizeMake(30, 30)]]];
                
                UILabel *infoLabel = [[UILabel alloc] init];
                infoLabel.text = self.user.phoneNumber;
                [cell setInfoLabel:infoLabel];
            }
            break;
        }
        case 3: {
            if (_user.phoneNumber) {
                FAKIonIcons *phoneIcon = [FAKIonIcons ios7TelephoneOutlineIconWithSize:30];
                [phoneIcon addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor darkGrayColor]];
                [cell setIconImageView:[[UIImageView alloc]
                         initWithImage:[phoneIcon imageWithSize:CGSizeMake(30, 30)]]];
                
                UILabel *infoLabel = [[UILabel alloc] init];
                infoLabel.text = self.user.phoneNumber;
                [cell setInfoLabel:infoLabel];
            }
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
    _profilePictureView.contentMode = UIViewContentModeScaleAspectFill;
    _profilePictureView.clipsToBounds = YES;
    [self setRoundedView:_profilePictureView];
    if (_user.profilePicture) {
        //do prof pic from server
    } else if (_user.profilePictureId) {
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL:
                             [NSURL URLWithString:
                              [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal", _user.profilePictureId]]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_profilePictureView setImage:[UIImage imageWithData:data]];
            });
        });
    } else {
        [_profilePictureView setImage:[UIImage imageNamed:@"hill.png"]];
    }
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
        make.top.equalTo(@(topMargin + 15));
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 1.f;
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_userInformationArray count] + 1;
}


@end
