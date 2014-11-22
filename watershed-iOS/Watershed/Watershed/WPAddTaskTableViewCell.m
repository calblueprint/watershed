//
//  WPAddTaskTableViewCell.m
//  Watershed
//
//  Created by Jordeen Chang on 11/22/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPAddTaskTableViewCell.h"

@implementation WPAddTaskTableViewCell {
    UILabel *label;
    UITextField *labelField;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *) reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self updateConstraints];
        CGRect labelRect = CGRectMake(15, 5, 200, 30);
        label = [[UILabel alloc] initWithFrame:labelRect];
        label.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:label];
        
        CGRect labelFieldRect = CGRectMake(15, 30, 200, 30);
        labelField = [[UITextField alloc] initWithFrame:labelFieldRect];
        labelField.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:labelField];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
