//
//  WPMiniSiteTableViewCell.m
//  Watershed
//
//  Created by Andrew Millman on 10/13/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPMiniSiteTableViewCell.h"

@interface WPMiniSiteTableViewCell()

@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UIImageView *photoView;
@property (nonatomic) UIView *ratingDotView;
@property (nonatomic) WPLabeledIcon *taskCountLabel;
@property (nonatomic) WPLabeledIcon *fieldReportCountLabel;
@property (nonatomic) NSString *name;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSInteger rating;
@property (nonatomic) NSInteger taskCount;
@property (nonatomic) NSInteger fieldReportCount;

@end

@implementation WPMiniSiteTableViewCell

const static float CELL_HEIGHT = 86.0f;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
               name:(NSString *)name
              image:(UIImage *)image
             rating:(NSInteger)rating
          taskCount:(NSInteger)taskCount
   fieldReportCount:(NSInteger)fieldReportCount {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
        
        _name = name;
        _image = image;
        _rating = rating;
        _taskCount = taskCount;
        _fieldReportCount = fieldReportCount;
       
        [self createSubviews];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)createSubviews {
    UIView *content = self.contentView;
    content.backgroundColor = [UIColor whiteColor];
    
    _nameLabel = [({
        UILabel *label = [[UILabel alloc] init];
        label.text = self.name;
        label;
    }) wp_addToSuperview:content];
    
    _photoView = [({
        UIImageView *photoView = [[UIImageView alloc] initWithImage:self.image];
        [photoView setContentMode:UIViewContentModeScaleAspectFill];
        [photoView setClipsToBounds:YES];
        photoView.layer.cornerRadius = 3.0;
        photoView;
    }) wp_addToSuperview:content];
    
    _ratingDotView = [({
        UIView *ratingDotView = [[UIView alloc] init];
        ratingDotView.layer.cornerRadius = 5.0;
        ratingDotView.backgroundColor = [WPMiniSiteTableViewCell colorForRating:self.rating];
        ratingDotView;
    }) wp_addToSuperview:content];
    
    _taskCountLabel = [({
        FAKFontAwesome *checkIcon = [FAKFontAwesome checkIconWithSize:[WPLabeledIcon viewHeight]];
        UIImage *checkImage = [checkIcon imageWithSize:CGSizeMake([WPLabeledIcon viewHeight], [WPLabeledIcon viewHeight])];
        
        NSString *taskText = [NSString stringWithFormat:@"%d tasks", (int) self.taskCount];
        WPLabeledIcon *taskCountLabel = [[WPLabeledIcon alloc] initWithText:taskText
                                                                       icon:checkImage];
        taskCountLabel.alpha = 0.3;
        taskCountLabel;
    }) wp_addToSuperview:content];
    
    _fieldReportCountLabel = [({
        FAKFontAwesome *exclamationIcon = [FAKFontAwesome exclamationTriangleIconWithSize:[WPLabeledIcon viewHeight]];
        UIImage *exclamationImage = [exclamationIcon imageWithSize:CGSizeMake([WPLabeledIcon viewHeight], [WPLabeledIcon viewHeight])];
        
        NSString *fieldReportText = [NSString stringWithFormat:@"%d reports", (int) self.fieldReportCount];
        WPLabeledIcon *fieldReportCountLabel = [[WPLabeledIcon alloc] initWithText:fieldReportText
                                                                              icon:exclamationImage];
        fieldReportCountLabel.alpha = 0.3;
        fieldReportCountLabel;
    }) wp_addToSuperview:content];
}

- (void)updateConstraints {
    
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.width.equalTo(@40);
        make.top.equalTo(@(standardMargin));
        make.leading.equalTo(@(standardMargin));
    }];
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.greaterThanOrEqualTo(@40);
        make.top.equalTo(self.photoView.mas_top);
        make.leading.equalTo(self.photoView.mas_trailing)
            .with.offset(standardMargin);
        make.trailing.equalTo(self.ratingDotView.mas_leading)
            .with.offset(-standardMargin);
    }];
    
    [self.ratingDotView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(standardMargin));
        make.width.equalTo(@(standardMargin));
        make.top.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];
    
    [self.taskCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom)
            .with.offset(standardMargin);
        make.leading.equalTo(self.photoView.mas_leading);
    }];
    
    [self.fieldReportCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom)
            .with.offset(standardMargin);
        make.leading.equalTo(self.taskCountLabel.mas_trailing)
            .with.offset(standardMargin);
    }];
    
    [super updateConstraints];
}

#pragma mark - UIView Modifications

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight { return CELL_HEIGHT; }

+ (UIColor *)colorForRating:(NSInteger)rating {
    switch (rating) {
        case 1:
            return [UIColor wp_red];
            break;
            
        case 2:
            return [UIColor wp_orange];
            break;
            
        case 3:
            return [UIColor wp_yellow];
            break;
            
        case 4:
            return [UIColor wp_lime];
            break;
            
        case 5:
            return [UIColor wp_green];
            break;
        default:
            return [UIColor grayColor];
            break;
    }
}

@end
