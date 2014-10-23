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
    if (self)
    {
        [self updateConstraints];
    }
    return self;
}

- (void)addSubviews {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.infoLabel];
}

- (void)updateConstraints {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.leading.equalTo(self.iconImageView.mas_right).with.offset(5);
        make.height.equalTo(@50);
        make.width.equalTo(@100);
        
    }];
}
@end
