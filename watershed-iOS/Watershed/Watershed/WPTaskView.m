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
//@property (nonatomic) UILabel *completed;
@property (nonatomic) UIButton *completed;

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
        UIButton *completed = [[UIButton alloc] init];
        completed.layer.cornerRadius = 10.0f;
        completed.layer.borderColor = [UIColor wp_blue].CGColor;
        completed.layer.borderWidth = 2.0f;
        completed.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        completed;
    }) wp_addToSuperview:self];

}

- (void)setUpActions {
    [_completed setTitle:@"Mark as Complete" forState:UIControlStateNormal];
    [_completed setTitleColor:[UIColor wp_blue] forState:UIControlStateNormal];
    [_completed addTarget:self action:@selector(onclick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)onclick{
    if (_completed.backgroundColor == [UIColor wp_green]) {
        [_completed setTitle:@"Mark as Complete" forState:UIControlStateNormal];
        [_completed setTitleColor:[UIColor wp_blue] forState:UIControlStateNormal];
        _completed.layer.borderWidth = 2.0f;
        NSLog(@"at the top bitch");
    } else {
        [_completed setTitle:@"Completed" forState:UIControlStateNormal];
        _completed.backgroundColor = [UIColor wp_green];
        [_completed setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _completed.layer.borderWidth = 0;
        NSLog(@"now at the bottom");
    }
}

- (void)updateConstraints {
    [self.dueDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.width.equalTo(@125);
        make.trailing.equalTo(@(-(stdMargin)));
    }];

    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.leading.equalTo(@(stdMargin));
        make.trailing.equalTo(self.dueDate.mas_left).with.offset(stdMargin);
    }];

    [self.taskDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dueDate.mas_bottom).with.offset(stdMargin);
        make.leading.equalTo(@(stdMargin));
        make.trailing.equalTo(@(-(stdMargin)));
    }];

    [self.completed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskDescription.mas_bottom).with.offset(stdMargin * 2);
        make.centerX.equalTo(@(self.center.x));
        make.height.equalTo(@50);
        make.width.equalTo(@200);
    }];

     [super updateConstraints];
}

@end
