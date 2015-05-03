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
@property (nonatomic) UIActivityIndicatorView *indicatorView;
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
        [self createSubviews];
    }

    return self;
}

#pragma mark - Public Methods

- (void)configureWithUser:(WPUser *)user {
    self.user = user;
    if ([[WPNetworkingManager sharedManager] keyChainStore][@"profilePictureId"]) {
        self.user.profilePictureId = [[WPNetworkingManager sharedManager] keyChainStore][@"profilePictureId"];
    }

    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal", _user.profilePictureId]];
    [self.profilePictureView setImageWithURL:pictureURL placeholderImage:[UIImage imageNamed:@"hill.png"]];

    self.nameLabel.text = self.user.name;

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
    if (user.role) {
        [_userInformationArray addObject:user.role];
    }

    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    self.infoTableView.scrollEnabled = YES;
    [self.infoTableView reloadData];
    [self setNeedsUpdateConstraints];
}

- (void)stopIndicator {
    [self.indicatorView stopAnimating];
    self.indicatorView.alpha = 0;
    self.profilePictureView.alpha = 1;
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
            FAKIonIcons *mailIcon = [FAKIonIcons androidMailIconWithSize:26];
            [mailIcon addAttribute:NSForegroundColorAttributeName
                             value:[UIColor darkGrayColor]];
            [cell setIconImageView:[[UIImageView alloc]
                     initWithImage:[mailIcon imageWithSize:CGSizeMake(26, 26)]]];
            
            
            UILabel *infoLabel = [[UILabel alloc] init];
            infoLabel.text = self.user.email;
            [cell setInfoLabel:infoLabel];
            
            break;
        }
        case 2: {
            if (_user.location) {
                FAKIonIcons *locationIcon = [FAKIonIcons pinIconWithSize:26];
                [locationIcon addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor darkGrayColor]];
                [cell setIconImageView:[[UIImageView alloc]
                         initWithImage:[locationIcon imageWithSize:CGSizeMake(26, 26)]]];
                
                UILabel *infoLabel = [[UILabel alloc] init];
                infoLabel.text = self.user.location;
                [cell setInfoLabel:infoLabel];
            } else {
                FAKIonIcons *phoneIcon = [FAKIonIcons androidCallIconWithSize:26];
                [phoneIcon addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor darkGrayColor]];
                [cell setIconImageView:[[UIImageView alloc]
                                        initWithImage:[phoneIcon imageWithSize:CGSizeMake(26, 26)]]];
                
                UILabel *infoLabel = [[UILabel alloc] init];
                infoLabel.text = self.user.phoneNumber;
                [cell setInfoLabel:infoLabel];
            }
            break;
        }
        case 3: {
            if (_user.phoneNumber) {
                FAKIonIcons *phoneIcon = [FAKIonIcons androidCallIconWithSize:26];
                [phoneIcon addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor darkGrayColor]];
                [cell setIconImageView:[[UIImageView alloc]
                         initWithImage:[phoneIcon imageWithSize:CGSizeMake(26, 26)]]];
                
                UILabel *infoLabel = [[UILabel alloc] init];
                infoLabel.text = self.user.phoneNumber;
                [cell setInfoLabel:infoLabel];
            }
            break;
        }
        case 4: {
            if (_user.role) {
                
            }
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
    
    _profilePictureView = [({
        UIImageView *pictureView = [[UIImageView alloc] init];
        pictureView.contentMode = UIViewContentModeScaleAspectFill;
        pictureView.clipsToBounds = YES;
        pictureView.alpha = 0;
        [self setRoundedView:pictureView];
        pictureView;
    }) wp_addToSuperview:self];

    _nameLabel = [({
        UILabel *label = [[UILabel alloc] init];
        label.text = self.user.name;
        label.textColor = [UIColor blackColor];
        label;
    }) wp_addToSuperview:self];

    _infoTableView = [({
        UITableView *tableView = [[UITableView alloc] init];
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        tableView;
    }) wp_addToSuperview:self];

    _indicatorView = [({
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [view startAnimating];
        view;
    }) wp_addToSuperview:self];
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

    [self.indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).with.offset(topMargin + 2 * standardMargin); // For some reason topMargin in equalTo doesn't work...
        make.centerX.equalTo(self.mas_centerX);
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
