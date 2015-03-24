//
//  WPTableViewCell.m
//  Watershed
//
//  Created by Jordeen Chang on 10/12/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTasksTableViewCell.h"
#import "UIExtensions.h"
#import "WPTaskViewController.h"

@implementation WPTasksTableViewCell {
    UILabel *titleValue;
    UILabel *taskDescriptionValue;
    UILabel *dueDateValue;
    UILabel *completedValue;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *) reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self updateConstraints];
        CGRect titleValueRect = CGRectMake(15, 5, 200, 30);
        titleValue = [[UILabel alloc] initWithFrame:titleValueRect];
        titleValue.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:titleValue];
        
        CGRect descriptionValueRect = CGRectMake(15, 30, 200, 30);
        taskDescriptionValue = [[UILabel alloc] initWithFrame:descriptionValueRect];
        taskDescriptionValue.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:taskDescriptionValue];
        
        CGRect dueDateValueRect = CGRectMake([WPView getScreenWidth] - 275, 0, 260, 30);
        dueDateValue = [[UILabel alloc] initWithFrame:dueDateValueRect];
        dueDateValue.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:dueDateValue];

        CGRect completedRect = CGRectMake([WPView getScreenWidth] - 60, 25, 45, 25);
        completedValue = [[UILabel alloc] initWithFrame:completedRect];
        completedValue.font = [UIFont boldSystemFontOfSize:12];
        completedValue.text = @"DONE";
        completedValue.textAlignment = NSTextAlignmentCenter;
        completedValue.textColor = [UIColor whiteColor];
        completedValue.alpha = 0;
        completedValue.backgroundColor = [UIColor wp_lightGreen];
        completedValue.layer.cornerRadius = 5.0;
        completedValue.clipsToBounds = YES;
        [self.contentView addSubview:completedValue];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void) setTitle:(NSString *)t {
    if (![t isEqualToString:_title]) {
        _title = [t copy];
        titleValue.text = _title;
        titleValue.textColor = [UIColor wp_darkBlue];
    }
}

-(void) setTaskDescription:(NSString *)d {
    if (![d isEqualToString:_taskDescription]) {
        _taskDescription = [d copy];
        taskDescriptionValue.text = _taskDescription;
        taskDescriptionValue.textColor = [UIColor grayColor];
    }
}

-(void) setDueDate:(NSString *)dd {
    if (![dd isEqualToString:_dueDate]) {
        _dueDate = [dd copy];
        //NSDate instead?
        dueDateValue.text = _dueDate;
        dueDateValue.textAlignment = NSTextAlignmentRight;
        dueDateValue.textColor = [UIColor wp_blue];
    }
}

- (void)setCompleted:(BOOL)completed {
    if (completed) {
        completedValue.alpha = 1;
    } else {
        completedValue.alpha = 0;
    }
}

@end
