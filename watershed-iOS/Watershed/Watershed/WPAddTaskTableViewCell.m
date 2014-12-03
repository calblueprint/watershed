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

NSInteger labelWidth = 90;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *) reuseIdentifier
    andControl: (UIControl *) control {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createSubviews];
        _control = control;
        [self.contentView addSubview:_control];
        [self updateConstraints];
    }
    return self;
}

- (void)createSubviews {
    _label = [({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor wp_header];
        label.font = [UIFont boldSystemFontOfSize:16];
        label;
    }) wp_addToSuperview:self.contentView];
}

- (void)updateConstraints {

    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_leading).with.offset(standardMargin);
        make.width.equalTo(@(labelWidth));
    }];
    
    [self.control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(standardMargin);
        make.left.equalTo(self.label.mas_right).with.offset(standardMargin);
        make.right.equalTo(self.contentView.mas_right).with.offset(-standardMargin);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-standardMargin);
    }];

    [super updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
