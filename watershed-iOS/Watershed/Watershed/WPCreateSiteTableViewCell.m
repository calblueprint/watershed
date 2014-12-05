//
//  WPCreateSiteTableViewCell.m
//  Watershed
//
//  Created by Andrew on 12/3/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPCreateSiteTableViewCell.h"

@implementation WPCreateSiteTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
        [self updateConstraints];
    }
    return self;
}

- (void)createSubviews {
    _textInput = [({
        [[UIView alloc] init];
    }) wp_addToSuperview:self.contentView];
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
    
    [self.textInput mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@15);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [super updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)setTextInput:(UIView *)textInput {
    [_textInput removeFromSuperview];
    _textInput = textInput;
    [self.contentView addSubview:_textInput];
}

@end
