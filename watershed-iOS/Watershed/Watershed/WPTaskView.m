//
//  WPTaskView.m
//  Watershed
//
//  Created by Jordeen Chang on 10/19/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTaskView.h"
#import "UIExtensions.h"

@interface WPTaskView()

@property (nonatomic) UILabel *title;
@property (nonatomic) UILabel *taskDescription;
@property (nonatomic) UILabel *dueDate;
@property (nonatomic) UILabel *completed;

@end

@implementation WPTaskView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
        [self setUpActions];
        [self updateConstraints];
    }
    return self;
}

- (void)createSubviews {
    _title = [({
        UILabel *title = [[UILabel alloc] init];
        title.backgroundColor = [UIColor wp_blue];
        title.text = @"Plant tree";
        title;
    }) wp_addToSuperview:self];
    
    _taskDescription = [({
        UILabel *taskDescription = [[UILabel alloc] init];
        taskDescription.backgroundColor = [UIColor wp_lightBlue];
        taskDescription.text = @"Please plant this tree in this spot by using a shovel. Dig a hole 1 meter in diameter and then yay.";
        taskDescription;
    }) wp_addToSuperview:self];
    
    _dueDate = [({
        UILabel *dueDate = [[UILabel alloc] init];
        dueDate.backgroundColor = [UIColor wp_darkBlue];
        dueDate.text = @"09/23/14";
        dueDate;
    }) wp_addToSuperview:self];
    
    _completed = [({
        UILabel *completed = [[UILabel alloc] init];
        completed.backgroundColor = [UIColor grayColor];
        completed;
    }) wp_addToSuperview:self];

}

- (void)setUpActions {

}

- (void)updateConstraints {
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@64);
        make.leading.equalTo(@10);
        make.trailing.equalTo(@(-10));
        make.height.equalTo(@50);
    }];
    
    [self.dueDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).with.offset(10);
        make.height.equalTo(@30);
        make.leading.equalTo(@10);
        make.trailing.equalTo(@(-10));
    }];

    [self.taskDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dueDate.mas_bottom).with.offset(10);
        make.leading.equalTo(@10);
        make.trailing.equalTo(@(-10));
        make.height.equalTo(@50);
    }];

    [self.completed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskDescription.mas_bottom).with.offset(10);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.equalTo(@10);
    }];
    
     [super updateConstraints];
}

@end
