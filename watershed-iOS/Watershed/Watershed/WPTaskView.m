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
        title;
    }) wp_addToSuperview:self];
    
    _taskDescription = [({
        UILabel *title = [[UILabel alloc] init];
        title;
    }) wp_addToSuperview:self];
    
    _dueDate = [({
        UILabel *title = [[UILabel alloc] init];
        title;
    }) wp_addToSuperview:self];
    
    _completed = [({
        UILabel *title = [[UILabel alloc] init];
        title;
    }) wp_addToSuperview:self];

}

- (void)setUpActions {

}

- (void)updateConstraints {
     [super updateConstraints];
}

@end
