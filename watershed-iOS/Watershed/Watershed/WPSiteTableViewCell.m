//
//  WPSiteTableViewCell.m
//  Watershed
//
//  Created by Andrew on 10/26/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSiteTableViewCell.h"

@interface WPSiteTableViewCell ()

@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UIImageView *photoView;
@property (nonatomic) UILabel *miniSiteLabel;
@property (nonatomic) UIView *darkOverlay;

@end

@implementation WPSiteTableViewCell

const static float CELL_HEIGHT = 150.0f;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
               name:(NSString *)name
              image:(UIImage *)image
      miniSiteCount:(NSInteger)miniSiteCount {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIView *content = self.contentView;
        content.backgroundColor = [UIColor whiteColor];
        
        _photoView = [({
            UIImageView *photoView = [[UIImageView alloc] initWithImage:image];
            [photoView setContentMode:UIViewContentModeScaleAspectFill];
            [photoView setClipsToBounds:YES];
            photoView;
        }) wp_addToSuperview:content];
        
        _darkOverlay = [({
            UIView *darkOverlay = [[UIView alloc] init];
            darkOverlay.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
            darkOverlay;
        }) wp_addToSuperview:content];
        
        _nameLabel = [({
            UILabel *label = [[UILabel alloc] init];
            label.text = name;
            label.font = [UIFont systemFontOfSize:20.0];
            label;
        }) wp_addToSuperview:content];
        
        _miniSiteLabel = [({
            UILabel *miniSiteLabel = [[UILabel alloc] init];
            miniSiteLabel.text = [NSString stringWithFormat:@"%d mini sites", (int)miniSiteCount];
            miniSiteLabel.font = [UIFont systemFontOfSize:14.0];
            miniSiteLabel;
        }) wp_addToSuperview:content];
        
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (CGFloat)cellHeight { return CELL_HEIGHT; }

@end
