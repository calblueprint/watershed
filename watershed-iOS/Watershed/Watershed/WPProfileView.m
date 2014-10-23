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

@end


@implementation WPProfileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubviews];
        //[self setUpActions];
        [self updateConstraints];
    }
    return self;
}

- (void)createProfiles {
    WPProfile *maxWolffe = [[WPProfile alloc] init];
    [maxWolffe setProfilePicture:@"max"];
    [maxWolffe setUserId:[NSNumber numberWithInt:5]];
    [maxWolffe setName:@"Max Wolffe"];
    [maxWolffe setPhoneNumber:@"9162128793"];
    [maxWolffe setEmail:@"max@millman.com"];
}

#pragma mark - View Hierarchy

-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.borderWidth = 1.0f;
    roundedView.layer.borderColor = [UIColor blackColor].CGColor;
    roundedView.layer.cornerRadius = 65/2;
    roundedView.center = saveCenter;
}

-(void)populateTableView {

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:allTasksIdentifier forIndexPath:indexPath];
    
    NSDictionary *rowData = self.infoArray[indexPath.row];
    cell.icon = rowData[@"Icon"];
    cell.text = rowData[@"Text"];
    return cell;

}


- (void)createSubviews {

    UIImageView *profilePictureView = [[UIImageView alloc] init];
    profilePictureView.contentMode = UIViewContentModeScaleAspectFit;
    profilePictureView.clipsToBounds = YES;
    [self setRoundedView:profilePictureView toDiameter:10];
    [profilePictureView setImage:[UIImage imageNamed:@"max.png"]];
    _profilePictureView = profilePictureView;
    [self addSubview:profilePictureView];


    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"Max Wolffe";
    _nameLabel.textColor = [UIColor blackColor];
    [self addSubview:_nameLabel];
    
    _infoTableView = [[UITableView alloc] init];
    
    FAKIonIcons *locationIcon = [FAKIonIcons ios7LocationOutlineIconWithSize:20];
    _locationIconImageView = [[UIImageView alloc] init];
    [_locationIconImageView setImage:[locationIcon imageWithSize:CGSizeMake(20, 20)]];
    [self addSubview:_locationIconImageView];
    
    _locationLabel = [[UILabel alloc] init];
    _locationLabel.text = @"123 Cloyne Way Berkeley, CA 94709";
    _locationLabel.textColor = [UIColor blackColor];
    _locationLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
    [self addSubview:_locationLabel];
    
    FAKIonIcons *mailIcon = [FAKIonIcons ios7EmailOutlineIconWithSize:17];
    _mailIconImageView = [[UIImageView alloc] init];
    [_mailIconImageView setImage:[mailIcon imageWithSize:CGSizeMake(15, 15)]];
    [self addSubview:_mailIconImageView];

    
}

- (void)updateConstraints {

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profilePictureView.mas_bottom).with.offset(7);
        make.centerX.equalTo(@0);
        make.height.equalTo(@50);
    }];

    [self.locationIconImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.locationIconImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    [self.locationIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@215);
        make.leading.equalTo(@55);
    }];
    

    [super updateConstraints];
}


@end
