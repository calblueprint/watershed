//
//  WPAboutView.m
//  Watershed
//
//  Created by Andrew Millman on 1/20/15.
//  Copyright (c) 2015 Blueprint. All rights reserved.
//

#import "WPAboutView.h"

@implementation WPAboutView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubviews];
        [self setNeedsUpdateConstraints];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"about_watershed.png"]];
    }
    return self;
}

- (void)createSubviews {
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"ABOUT THE WATERSHED PROJECT";
    _titleLabel.font = [UIFont boldSystemFontOfSize:24.0];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.numberOfLines = 0;
    [self addSubview:_titleLabel];
    
    _aboutLabel = [[UILabel alloc] init];
    _aboutLabel.text = @"The Watershed Project's mission is to inspire Bay Area communities to understand, appreciate and protect our local watersheds. Located at the University of California's Richmond Field Station, since 1997 we have pursued this vision through various initiatives. The Healthy Watersheds Initiative focuses on litter and other source of pollutants. The Living Shoreline Initiative aims to help people appreciate the rich potential for healthy underwater habitats in the Bay and along it's shoreline, with an emphasis on native Oyster restoration. The Greening Urban Watersheds Initiative seeks to redefine the way we inhabit our urban centers, envisioning a green cityscape that maintains or mimics the natural flows and rhythms of local ecosystems. ";
    _aboutLabel.font = [UIFont systemFontOfSize:18];
    _aboutLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _aboutLabel.numberOfLines = 0;
    _aboutLabel.textColor = [UIColor whiteColor];
    [self addSubview:_aboutLabel];
    
}

- (void)updateConstraints {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin + standardMargin));
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];
    
    [self.aboutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(standardMargin);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];
    
    
    [super updateConstraints];
}

@end
