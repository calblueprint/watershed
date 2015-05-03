//
//  WPPromoteTableViewCell.m
//  Watershed
//
//  Created by Jordeen Chang on 5/3/15.
//  Copyright (c) 2015 Blueprint. All rights reserved.
//

#import "WPPromoteTableViewCell.h"
#import "UIExtensions.h"

@implementation WPPromoteTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setNeedsUpdateConstraints];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    return self;
}

- (void)addSubviews {
    [self.contentView addSubview:self.userLabel];
    [self.contentView addSubview:self.promoteButton];
}

- (void)updateConstraints {
    
    [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@15);
    }];
    
    [self.promoteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(@-15);
    }];
    
    [super updateConstraints];
}
@end