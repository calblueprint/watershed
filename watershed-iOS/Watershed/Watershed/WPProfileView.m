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

#import <QuartzCore/QuartzCore.h>

@interface WPProfileView ()

@property (nonatomic) UIView *profilePictureView;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UIView *tasksView;
@property (nonatomic) UIView *tasksLabel;
@property (nonatomic) UIView *tasksNumber;
@property (nonatomic) UIView *sitesView;

@end


@implementation WPProfileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor wp_blue];
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
    roundedView.layer.borderWidth = 2.0f;
    roundedView.layer.borderColor = [UIColor whiteColor].CGColor;

    roundedView.layer.cornerRadius = 75/2;
    roundedView.center = saveCenter;
}

- (void)createSubviews {

    UIImageView *profilePictureView = [[UIImageView alloc] init];
    profilePictureView.contentMode = UIViewContentModeScaleAspectFit;
    profilePictureView.clipsToBounds = YES;
    [self setRoundedView:profilePictureView toDiameter:20];
    [profilePictureView setImage:[UIImage imageNamed:@"max.png"]];
    _profilePictureView = profilePictureView;
    [self addSubview:profilePictureView];


    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"Max Wolffe";
    nameLabel.textColor = [UIColor whiteColor];
    _nameLabel = nameLabel;
    [self addSubview:nameLabel];
    
    
    
    UIView *tasksView = [[UIView alloc] init];
    tasksView.layer.borderWidth = 0.5f;
    tasksView.layer.borderColor = [UIColor grayColor].CGColor;
    _tasksView = tasksView;
    [self addSubview:tasksView];
    
    UILabel *tasksNumber = [[UILabel alloc] init];
    tasksNumber.text = @"3";
    tasksNumber.textColor = [UIColor whiteColor];
    _tasksNumber = tasksNumber;
    [tasksView addSubview:tasksNumber];
    
    UILabel *tasksLabel = [[UILabel alloc] init];
    tasksLabel.text = @"Tasks";
    tasksLabel.textColor = [UIColor whiteColor];
    _tasksLabel = tasksLabel;
    [tasksView addSubview:tasksLabel];
    
    UIView *sitesView = [[UIView alloc] init];
    sitesView.layer.borderWidth = 0.5f;
    sitesView.layer.borderColor = [UIColor grayColor].CGColor;
    _sitesView = sitesView;
    [self addSubview:sitesView];
    
}

- (void)updateConstraints {

    [self.profilePictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@100);
        make.leading.equalTo(@40);
        make.height.equalTo(@75);
        make.width.equalTo(@75);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@110);
        make.leading.equalTo(@125);
        make.height.equalTo(@50);
        make.width.equalTo(@100);
    }];
    
    [self.tasksView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@200);
        make.leading.equalTo(@0);
        make.height.equalTo(@40);
        make.width.equalTo(@160);
    }];
    [self.tasksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.leading.equalTo(@30);
        make.height.equalTo(@10);
        make.width.equalTo(@20);
    }];
    [self.tasksNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.leading.equalTo(@30);
        make.height.equalTo(@10);
        make.width.equalTo(@20);
    }];
    
    [self.sitesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@200);
        make.trailing.equalTo(@0);
        make.height.equalTo(@40);
        make.width.equalTo(@160);
    }];
    
    [super updateConstraints];
}


@end
