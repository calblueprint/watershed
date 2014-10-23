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
        [self updateConstraints];
        [self setUpActions];
    }
    return self;
}

- (void)createSubviews {
    _title = [({
        UILabel *title = [[UILabel alloc] init];
        title.text = @"Plant tree";
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
        UILabel *completed = [[UILabel alloc] init];
        completed.backgroundColor = [UIColor greenColor];
        completed;
    }) wp_addToSuperview:self];

}

- (void)setUpActions {

}

- (void)updateConstraints {
    [self.dueDate mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(self.title.mas_bottom).with.offset(10);
        make.top.equalTo(@64);
        //        make.leading.equalTo(@10);
        make.width.equalTo(@125);
//        make.leading.equalTo(self.title.mas_right).with.offset(10);
        make.trailing.equalTo(@(-15));
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@64);
        make.leading.equalTo(@15);
        make.trailing.equalTo(self.dueDate.mas_left).with.offset(15);
    }];

    [self.taskDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dueDate.mas_bottom).with.offset(15);
        make.leading.equalTo(@15);
        make.trailing.equalTo(@(-15));
    }];

    [self.completed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskDescription.mas_bottom).with.offset(15);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.equalTo(@15);
    }];
    
     [super updateConstraints];
}

@end
