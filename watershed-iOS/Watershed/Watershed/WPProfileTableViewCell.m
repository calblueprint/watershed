//
//  WPProfileTableViewCell.m
//  Watershed
//
//  Created by Melissa Huang on 10/19/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPProfileTableViewCell.h"

@implementation WPProfileTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier profile:(WPProfile *)profile {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self updateConstraints];
        self.profile = profile;
        [self setAttributes];
    }
    return self;
}

- (void)setAttributes {
    
    UIImageView *profilePicture = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.profile.profilePicture]];
    [self.contentView addSubview:profilePicture];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = self.profile.name;
    
    UILabel *emailLabel = [[UILabel alloc] init];
    emailLabel.text = self.profile.email;
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.text = self.profile.phoneNumber;
    
}

@end
