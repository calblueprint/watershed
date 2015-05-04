//
//  WPTaskView.m
//  Watershed
//
//  Created by Jordeen Chang on 10/19/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTaskView.h"
#import "UIExtensions.h"
#import "WPTask.h"

int WPButtonHeight = 75;


@implementation WPTaskView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame visibleNavbar:YES];
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
        title.numberOfLines = 0;
        title.font = [UIFont boldSystemFontOfSize:30];
        title.textColor = [UIColor wp_darkBlue];
        title;
    }) wp_addToSuperview:self];
    
    _siteLinkButton = [({
        UIButton *siteLinkButton = [[UIButton alloc] init];
        siteLinkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        siteLinkButton.titleLabel.font = [UIFont systemFontOfSize:18];
        siteLinkButton.titleLabel.textColor = [UIColor grayColor];
        siteLinkButton;
    }) wp_addToSuperview:self];
    
    _taskDescription = [({
        UILabel *taskDescription = [[UILabel alloc] init];
        taskDescription.numberOfLines = 0;
        taskDescription.textColor = [UIColor wp_darkBlue];
        taskDescription;
    }) wp_addToSuperview:self];
    
    _assigneeLabel = [({
        UILabel *assignee = [[UILabel alloc] init];
        assignee.numberOfLines = 0;
        assignee.font = [UIFont systemFontOfSize:18];
        assignee.textColor = [UIColor grayColor];
        assignee.textAlignment = NSTextAlignmentRight;
        assignee;
    }) wp_addToSuperview:self];
    
    _dueDate = [({
        UILabel *dueDate = [[UILabel alloc] init];
        dueDate.numberOfLines = 0;
        dueDate.font = [UIFont systemFontOfSize:20];
        dueDate.textColor = [UIColor darkGrayColor];
        dueDate.textAlignment = NSTextAlignmentRight;
        dueDate;
    }) wp_addToSuperview:self];

    _addFieldReportButton = [({
        UIButton *addFieldReportButton = [[UIButton alloc] init];
        addFieldReportButton.backgroundColor = [UIColor wp_darkBlue];
        addFieldReportButton.titleLabel.numberOfLines = 0;
        addFieldReportButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        addFieldReportButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        addFieldReportButton;
    }) wp_addToSuperview:self];

    _completed = [({
        UIButton *completed = [[UIButton alloc] init];
        completed.backgroundColor = [UIColor wp_lightBlue];
        completed.titleLabel.numberOfLines = 0;
        completed.titleLabel.textAlignment = NSTextAlignmentCenter;
        completed.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        completed;
    }) wp_addToSuperview:self];

}

- (void)setUpActions {
    [_completed setTitleColor:[UIColor wp_darkBlue] forState:UIControlStateNormal];
    [_completed setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_completed setBackgroundImage:[WPTaskView imageFromColor:[UIColor wp_lightGreen]] forState:UIControlStateSelected];
    [_addFieldReportButton setTitle:@"Add Field\nReport" forState:UIControlStateNormal];
    [_addFieldReportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_siteLinkButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)onClick {
    self.completed.selected = !self.completed.selected;
}

- (void)configureWithTask:(WPTask *)task {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"MMM dd, yyyy"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    NSDate *date  = [dateFormat dateFromString: task.dueDate];
    NSString *dueDateString = [outputFormatter stringFromDate:date];

    self.dueDate.text = dueDateString;
    self.taskDescription.text = task.taskDescription;
    NSString *assigneeText = @"";
    if (task.assignee == NULL) {
        assigneeText = [NSString stringWithFormat: @"Created by %@", task.assigner.name];
        [_completed setTitle:@"Claim this\nTask" forState:UIControlStateNormal];
        [_completed setTitle:@"Claimed" forState:UIControlStateSelected];
        [_completed addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    } else {
        assigneeText = [NSString stringWithFormat:@"Assigned to %@ by %@", task.assignee.name, task.assigner.name];
        [_completed setTitle:@"Mark as\nComplete" forState:UIControlStateNormal];
        [_completed setTitle:@"Completed" forState:UIControlStateSelected];
        [_completed addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    }
    self.assigneeLabel.text = assigneeText;
    self.title.text = task.title;
    if (!task.miniSite.name) {
        [self.siteLinkButton setTitle:@"Not assigned to a mini site" forState:UIControlStateNormal];
    } else {
        [self.siteLinkButton setTitle:task.miniSite.name forState:UIControlStateNormal];
    }
    if (task.completed) {
        [self.completed setSelected:YES];
    }
    self.task = task;
}

- (void)updateConstraints {
    [self.dueDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin + standardMargin));
        make.width.equalTo(@125);
        make.trailing.equalTo(@(-standardMargin));
        make.centerY.equalTo(self.title.mas_centerY);
    }];

    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin + standardMargin));
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(self.dueDate.mas_left).with.offset(standardMargin);
    }];
    
    [self.siteLinkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).with.offset(standardMargin);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
        make.height.equalTo(@(wpButtonHeight / 2));
    }];
    
    [self.taskDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.siteLinkButton.mas_bottom).with.offset(standardMargin);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];
    
    [self.assigneeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.addFieldReportButton.mas_top).with.offset(-standardMargin);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];

    [self.addFieldReportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.height.equalTo(@(WPButtonHeight));
        make.leading.equalTo(@0);
        make.trailing.equalTo(self.mas_centerX);
    }];

    [self.completed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.leading.equalTo(self.addFieldReportButton.mas_right);
        make.height.equalTo(@(WPButtonHeight));
        make.trailing.equalTo(@0);
        
    }];

     [super updateConstraints];
}

@end
