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

#import <QuartzCore/QuartzCore.h>

@interface WPProfileView ()

@property (nonatomic) UIView *profilePictureView;
@property (nonatomic) UILabel *nameLabel;
//@property (nonatomic) UIView *tasksView;
//@property (nonatomic) UIView *tasksLabel;
//@property (nonatomic) UIView *tasksNumber;
//@property (nonatomic) UIView *sitesView;
@property (nonatomic) UIView *locationView;
@property (nonatomic) UIView *locationIconView;
@property (nonatomic) UILabel *locationLabel;
@property (nonatomic) UIImageView *mailIconImageView;



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

- (void)createSubviews {

    UIImageView *profilePictureView = [[UIImageView alloc] init];
    profilePictureView.contentMode = UIViewContentModeScaleAspectFit;
    profilePictureView.clipsToBounds = YES;
    [self setRoundedView:profilePictureView toDiameter:10];
    [profilePictureView setImage:[UIImage imageNamed:@"max.png"]];
    _profilePictureView = profilePictureView;
    [self addSubview:profilePictureView];


    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"Max Wolffe";
    nameLabel.textColor = [UIColor blackColor];
    _nameLabel = nameLabel;
    [self addSubview:nameLabel];
    
    UIView *locationView = [[UIView alloc] init];
    [self addSubview:locationView];
    
    FAKIonIcons *locationIcon = [FAKIonIcons ios7LocationOutlineIconWithSize:20];
    _locationImageView = [[UIImageView alloc] init];
    [_mailIconImageView setImage:[mailIcon imageWithSize:CGSizeMake(15, 15)]];
    
    [self addSubview:_mailIconImageView];
    
    UILabel *locationLabel = [[UILabel alloc] init];
    locationLabel.text = @"123 Cloyne Way Berkeley, CA 94709";
    locationLabel.textColor = [UIColor blackColor];
    locationLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
    _locationLabel = locationLabel;
//    [self addSubview:locationLabel];
    [locationView addSubview:locationLabel];
    
    FAKIonIcons *mailIcon = [FAKIonIcons ios7EmailOutlineIconWithSize:20];
    _mailIconImageView = [[UIImageView alloc] init];
    [_mailIconImageView setImage:[mailIcon imageWithSize:CGSizeMake(15, 15)]];

    [self addSubview:_mailIconImageView];
    
//    UIView *tasksView = [[UIView alloc] init];
//    tasksView.layer.borderWidth = 0.5f;
//    tasksView.layer.borderColor = [UIColor grayColor].CGColor;
//    _tasksView = tasksView;
//    [self addSubview:tasksView];
//    
//    UILabel *tasksNumber = [[UILabel alloc] init];
//    tasksNumber.text = @"3";
//    tasksNumber.textColor = [UIColor whiteColor];
//    _tasksNumber = tasksNumber;
//    [tasksView addSubview:tasksNumber];
//    
//    UILabel *tasksLabel = [[UILabel alloc] init];
//    tasksLabel.text = @"Tasks";
//    tasksLabel.textColor = [UIColor whiteColor];
//    _tasksLabel = tasksLabel;
//    [tasksView addSubview:tasksLabel];
//    
//    UIView *sitesView = [[UIView alloc] init];
//    sitesView.layer.borderWidth = 0.5f;
//    sitesView.layer.borderColor = [UIColor grayColor].CGColor;
//    _sitesView = sitesView;
//    [self addSubview:sitesView];
    
}

- (void)updateConstraints {

    [self.profilePictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@100);
        make.leading.equalTo(@40);
        make.height.equalTo(@65);
        make.width.equalTo(@65);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@110);
        make.leading.equalTo(@125);
        make.height.equalTo(@50);
        make.width.equalTo(@100);
    }];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@220);
        make.leading.equalTo(@95);
        make.height.equalTo(@20);
        make.width.equalTo(@200);
    }];

    [self.locationIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@215);
        make.leading.equalTo(@55);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
    }];
    
    [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@110);
        make.leading.equalTo(@125);
        make.height.equalTo(@50);
        make.width.equalTo(@200);
    }];
    
    [self.mailIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@285);
        make.leading.equalTo(@55);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
    }];
    
//    [self.tasksView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@200);
//        make.leading.equalTo(@0);
//        make.height.equalTo(@40);
//        make.width.equalTo(@160);
//    }];
//    [self.tasksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@10);
//        make.leading.equalTo(@30);
//        make.height.equalTo(@10);
//        make.width.equalTo(@20);
//    }];
//    [self.tasksNumber mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@5);
//        make.leading.equalTo(@30);
//        make.height.equalTo(@10);
//        make.width.equalTo(@20);
//    }];
//    
//    [self.sitesView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@200);
//        make.trailing.equalTo(@0);
//        make.height.equalTo(@40);
//        make.width.equalTo(@160);
//    }];
    
    [super updateConstraints];
}


@end
