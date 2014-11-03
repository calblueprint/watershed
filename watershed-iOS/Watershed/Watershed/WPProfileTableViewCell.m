//
//  WPProfileTableViewCell.m
//  Watershed
//
//  Created by Melissa Huang on 10/19/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPProfileTableViewCell.h"
#import "Masonry.h"

@implementation WPProfileTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setNeedsUpdateConstraints];
    }
    self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    return self;
}

- (void)addSubviews {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.infoLabel];
}

- (void)updateConstraints {
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@15);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(@-15);
    }];
    
    [super updateConstraints];
}
@end
