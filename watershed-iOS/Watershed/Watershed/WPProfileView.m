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
#import "WPProfile.h"

#import <QuartzCore/QuartzCore.h>

@interface WPProfileView ()

@property UITableView *infoTableView;
@property WPProfile *profile;
@property UIImageView *profilePictureView;
@property UILabel *nameLabel;

@end


@implementation WPProfileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createProfiles];
        [self createSubviews];
        //[self setUpActions];
        [self updateConstraints];
    }
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    [self.infoTableView reloadData];
    return self;
}

- (void)createProfiles {
    self.profile = [[WPProfile alloc] init];
    [self.profile setProfilePicture:@"max.png"];
    [self.profile setUserId:[NSNumber numberWithInt:5]];
    [self.profile setName:@"Max Wolffe"];
    [self.profile setPhoneNumber:@"9162128793"];
    [self.profile setEmail:@"max@millman.com"];
    [self.profile setLocation:@"123 Millman Way Berkeley, CA 82918"];
}

#pragma mark - View Hierarchy

-(void)setRoundedView:(UIImageView *)roundedView;
{
    CGPoint saveCenter = roundedView.center;
    roundedView.layer.borderWidth = 1.0f;
    roundedView.layer.borderColor = [UIColor blackColor].CGColor;
    roundedView.layer.cornerRadius = 65/2;
    roundedView.center = saveCenter;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"WPProfileCell";
    WPProfileTableViewCell *cell = [[WPProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    switch (indexPath.row) {
        case 0: {
            FAKIonIcons *mailIcon = [FAKIonIcons ios7EmailOutlineIconWithSize:17];
            [cell setIconImageView:[[UIImageView alloc] initWithImage:[mailIcon imageWithSize:CGSizeMake(15, 15)]]];
            
            UILabel *infoLabel = [[UILabel alloc] init];
            infoLabel.text = self.profile.email;
            [cell setInfoLabel:infoLabel];
            
            break;
        }
        case 1: {
            FAKIonIcons *locationIcon = [FAKIonIcons ios7LocationOutlineIconWithSize:20];
            [cell setIconImageView:[[UIImageView alloc] initWithImage:[locationIcon imageWithSize:CGSizeMake(20, 20)]]];
            
            UILabel *infoLabel = [[UILabel alloc] init];
            infoLabel.text = self.profile.location;
            [cell setInfoLabel:infoLabel];
            break;
        }
        default: {
            //do nothing
        }
    }
    
    [cell addSubviews];
    return cell;
}


- (void)createSubviews {

    _profilePictureView = [[UIImageView alloc] init];
    _profilePictureView.contentMode = UIViewContentModeScaleAspectFit;
    _profilePictureView.clipsToBounds = YES;
    [self setRoundedView:_profilePictureView];
    [_profilePictureView setImage:[UIImage imageNamed:self.profile.profilePicture]];
    [self addSubview:_profilePictureView];


    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = self.profile.name;
    _nameLabel.textColor = [UIColor blackColor];
    [self addSubview:_nameLabel];
    
    _infoTableView = [[UITableView alloc] init];
    [self addSubview:_infoTableView];

    
}

- (void)updateConstraints {
    
    [self.profilePictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@79);
        make.centerX.equalTo(@0);
        make.height.equalTo(@65);
        make.width.equalTo(@65);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profilePictureView.mas_bottom).with.offset(7);
        make.centerX.equalTo(@0);
        make.height.equalTo(@50);
        make.width.equalTo(@100);

    }];
    
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(10);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
//    [self.infoTableView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@0);
//        make.leading.equalTo(@0);
//        make.trailing.equalTo(@0);
//        make.bottom.equalTo(@0);
//    }];

//    [self.locationIconImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
//    [self.locationIconImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];

    

    [super updateConstraints];
}

#pragma mark - Table View Protocols

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

@end
