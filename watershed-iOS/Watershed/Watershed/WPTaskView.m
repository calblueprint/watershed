//
//  WPTaskView.m
//  Watershed
//
//  Created by Jordeen Chang on 10/19/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTaskView.h"
#import "UIExtensions.h"

@implementation WPTaskView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
        [self updateConstraints];
        [self setUpActions];
    }
    return self;
}

- (void)createSubviews {
    _title = [({
        UILabel *title = [[UILabel alloc] init];
        title.text = @"PLANT TREE";
        title.numberOfLines = 0;
        title.font = [UIFont boldSystemFontOfSize:20.0];
        title.textColor = [UIColor wp_darkBlue];
        title;
    }) wp_addToSuperview:self];
    
    _taskDescription = [({
        UILabel *taskDescription = [[UILabel alloc] init];
        taskDescription.text = @"Please plant this tree in this spot by using a shovel. Dig a hole 1 meter in diameter and then yay.";
        taskDescription.numberOfLines = 0;
        taskDescription.textColor = [UIColor wp_darkBlue];
        taskDescription;
    }) wp_addToSuperview:self];
    
    _dueDate = [({
        UILabel *dueDate = [[UILabel alloc] init];
        dueDate.text = @"Due: 09/23/14";
        dueDate.numberOfLines = 0;
        dueDate.font = [UIFont systemFontOfSize:16.6];
        dueDate.textColor = [UIColor darkGrayColor];
        dueDate.textAlignment = NSTextAlignmentRight;
        dueDate;
    }) wp_addToSuperview:self];
    
    _completed = [({
        UIButton *completed = [[UIButton alloc] init];
        completed.layer.cornerRadius = wpCornerRadius;
        completed.layer.borderColor = [UIColor wp_blue].CGColor;
        completed.layer.borderWidth = wpBorderWidth;
        completed.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        completed;
    }) wp_addToSuperview:self];

}

- (void)setUpActions {
    [_completed setTitle:@"Mark as Complete" forState:UIControlStateNormal];
    [_completed setTitleColor:[UIColor wp_blue] forState:UIControlStateNormal];
    [_completed addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)onClick {
    if ([_completed.titleLabel.text isEqualToString:@"Completed"]) {
        [_completed setTitle:@"Mark as Complete" forState:UIControlStateNormal];
        [_completed setTitleColor:[UIColor wp_blue] forState:UIControlStateNormal];
        _completed.backgroundColor = [UIColor whiteColor];
        _completed.layer.borderWidth = wpCornerRadius;
    } else {
        [_completed setTitle:@"Completed" forState:UIControlStateNormal];
        _completed.backgroundColor = [UIColor wp_green];
        [_completed setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _completed.layer.borderWidth = 0;
    }
}

- (void)updateConstraints {
    [self.dueDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.width.equalTo(@125);
        make.trailing.equalTo(@(-standardMargin));
    }];

    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(self.dueDate.mas_left).with.offset(standardMargin);
    }];

    [self.taskDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).with.offset(standardMargin);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];

    [self.completed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskDescription.mas_bottom).with.offset(standardMargin * 2);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@50);
        make.width.equalTo(@200);
    }];

     [super updateConstraints];
}

@end
