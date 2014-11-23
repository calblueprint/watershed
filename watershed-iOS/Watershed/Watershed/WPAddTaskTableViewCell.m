//
//  WPAddTaskTableViewCell.m
//  Watershed
//
//  Created by Jordeen Chang on 11/22/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPAddTaskTableViewCell.h"
#import "UIExtensions.h"


@implementation WPAddTaskTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *) reuseIdentifier
    andControl: (UIControl *) control {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createSubviews];
        _control = control;
        [self.contentView addSubview:_control];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)createSubviews {
    _label = [({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont boldSystemFontOfSize:16];
        label;
    }) wp_addToSuperview:self.contentView];
}

- (void)updateConstraints {

    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(standardMargin);
        make.leading.equalTo(self.contentView.mas_leading).with.offset(standardMargin);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-standardMargin);
    }];
    
    [self.control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(standardMargin);
        make.leading.equalTo(self.label.mas_right).with.offset(standardMargin);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-standardMargin);
        make.bottom.equalTo(self.contentView.mas_trailing).with.offset(-standardMargin);
    }];

    [super updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
