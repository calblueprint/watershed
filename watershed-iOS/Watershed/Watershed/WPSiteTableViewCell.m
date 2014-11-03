//
//  WPSiteTableViewCell.m
//  Watershed
//
//  Created by Andrew Millman on 10/26/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSiteTableViewCell.h"

@interface WPSiteTableViewCell ()

@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UIImageView *photoView;
@property (nonatomic) UILabel *miniSiteLabel;
@property (nonatomic) UIView *darkOverlay;
@property (nonatomic) NSString *name;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSInteger miniSiteCount;

@end

@implementation WPSiteTableViewCell

const static float CELL_HEIGHT = 150.0f;
const static int ORIGINAL_PHOTO_POSITION = 50;
const static float PARALLAX_REDUCTION = 3.5;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
               name:(NSString *)name
              image:(UIImage *)image
      miniSiteCount:(NSInteger)miniSiteCount {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setClipsToBounds:YES];
        
        _name = name;
        _image = image;
        _miniSiteCount = miniSiteCount;
        
        [self createSubviews];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)createSubviews {
    
    UIView *content = self.contentView;
    content.backgroundColor = [UIColor whiteColor];
    
    _photoView = [({
        UIImageView *photoView = [[UIImageView alloc] initWithImage:self.image];
        [photoView setContentMode:UIViewContentModeScaleAspectFill];
        //[photoView setClipsToBounds:YES];
        photoView;
    }) wp_addToSuperview:content];
    
    _darkOverlay = [({
        UIView *darkOverlay = [[UIView alloc] init];
        darkOverlay.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.15];
        darkOverlay;
    }) wp_addToSuperview:content];
    
    _nameLabel = [({
        UILabel *label = [[UILabel alloc] init];
        label.text = self.name;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:20.0];
        [self addTextShadow:label];
        label;
    }) wp_addToSuperview:content];
    
    _miniSiteLabel = [({
        UILabel *miniSiteLabel = [[UILabel alloc] init];
        miniSiteLabel.text = [NSString stringWithFormat:@"%d mini sites", (int) self.miniSiteCount];
        miniSiteLabel.textColor = [UIColor whiteColor];
        miniSiteLabel.font = [UIFont systemFontOfSize:14.0];
        [self addTextShadow:miniSiteLabel];
        miniSiteLabel;
    }) wp_addToSuperview:content];
}

- (void)updateConstraints {
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(ORIGINAL_PHOTO_POSITION));
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [self.darkOverlay mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.miniSiteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo([UIView wp_styleNegativePadding]);
        make.trailing.equalTo([UIView wp_styleNegativePadding]);
    }];

    
    [super updateConstraints];
}

#pragma mark - UIView Modifications

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)updatePhotoPosition:(NSNumber *)contentOffset {
    CGFloat photoOffset = [contentOffset floatValue] - self.frame.origin.y;
    
    [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(ORIGINAL_PHOTO_POSITION + photoOffset / PARALLAX_REDUCTION));
    }];
}



- (void)addTextShadow:(UILabel *)label {
    label.layer.shadowColor = [[UIColor blackColor] CGColor];
    label.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    label.layer.shadowRadius = 4.0;
    label.layer.shadowOpacity = 1.0;
    label.layer.masksToBounds = NO;
    label.layer.shouldRasterize = YES;
}

+ (CGFloat)cellHeight { return CELL_HEIGHT; }

@end