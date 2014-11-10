//
//  WPAboutViewController.m
//  Watershed
//
//  Created by Melissa Huang on 11/9/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPAboutViewController.h"
#import "UIExtensions.h"

@implementation WPAboutViewController

- (void)viewDidLoad {
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.title = @"About";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)loadView {
    self.view = [[WPAboutView alloc] init];
}


@end

@implementation WPAboutView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubviews];
        [self setNeedsUpdateConstraints];
        self.backgroundColor = [UIColor wp_blue];
    }
    return self;
}

- (void)createSubviews {
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"The Watershed Project";
    [self addSubview:_titleLabel];
    
    _aboutLabel = [[UILabel alloc] init];
    _aboutLabel.text = @"The Watershed Project’s vision is “people committed to a healthy San Francisco Bay watershed.” Since 1997, we’ve pursued that vision through initiatives that: Restore and preserve our unique, local ecosystems. We are located in Richmond, California, on the University of California's Richmond Field Station.";
    _aboutLabel.font=  [UIFont systemFontOfSize:10];
    _aboutLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _aboutLabel.numberOfLines = 0;
    [self addSubview:_aboutLabel];

}

- (void)updateConstraints {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin + standardMargin));
        make.leading.equalTo(@(standardMargin));
    }];
    
    [self.aboutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(standardMargin);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];
    
    [super updateConstraints];
}

@end