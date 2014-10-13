//
//  WPTableViewCell.m
//  Watershed
//
//  Created by Jordeen Chang on 10/12/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTableViewCell.h"

@implementation WPTableViewCell {
    UILabel *titleValue;
    UILabel *taskDescriptionValue;
    UILabel *dueDateValue;
    UILabel *completedValue;
}

//- (void)awakeFromNib {
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *) reuseIdentifier {
    
    // Initialization code
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGRect titleRect = CGRectMake(0, 5, 70, 15);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleRect];
        titleLabel.text = @"Task: ";
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:titleLabel];
        
        CGRect descriptionRect = CGRectMake(0, 26, 70, 15);
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:descriptionRect];
        descriptionLabel.text = @"Description: ";
        descriptionLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:titleLabel];
        
        //    CGRect descriptionRect = CGRectMake(0, 26, 70, 15);
        //    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:descriptionRect];
        //    descriptionLabel.text = @"Description: ";
        //    descriptionLabel.textAlignment = NSTextAlignmentLeft;
        //    [self.contentView addSubview:titleLabel];
        
        CGRect titleValueRect = CGRectMake(80, 5, 200, 30);
        titleValue = [[UILabel alloc] initWithFrame:titleValueRect];
        [self.contentView addSubview:titleValue];
        
        CGRect descriptionValueRect = CGRectMake(80, 25, 200, 30);
        taskDescriptionValue= [[UILabel alloc] initWithFrame:descriptionValueRect];
        [self.contentView addSubview:taskDescriptionValue];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//////////////////ADDED ALL FUNCTIONS AFTER THIS/////////////

-(void) setTitle:(NSString *)t {
    if (![t isEqualToString:_title]) {
        _title = [t copy];
        titleValue.text = _title;
    }
}

-(void) setDescription:(NSString *)d {
    if (![d isEqualToString:_taskDescription]) {
        _taskDescription = [d copy];
        taskDescriptionValue.text = _taskDescription;
    }
}
@end
