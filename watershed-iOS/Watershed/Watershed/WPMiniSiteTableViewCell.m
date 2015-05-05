//
//  WPMiniSiteTableViewCell.m
//  Watershed
//
//  Created by Andrew Millman on 10/13/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPMiniSiteTableViewCell.h"

@implementation WPMiniSiteTableViewCell

const static float CELL_HEIGHT = 86.0f;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];

        [self createSubviews];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)dealloc {
    [self.photoView cancelImageRequestOperation];
}

#pragma mark - View Hierarchy

- (void)createSubviews {
    UIView *content = self.contentView;
    content.backgroundColor = [UIColor whiteColor];

    _nameLabel = [({
        UILabel *label = [[UILabel alloc] init];
        //label.text = self.name;
        label;
    }) wp_addToSuperview:content];

    _photoView = [({
        UIImageView *photoView = [[UIImageView alloc] init];
        [photoView setContentMode:UIViewContentModeScaleAspectFill];
        [photoView setClipsToBounds:YES];
        photoView.layer.cornerRadius = 3.0;
        photoView;
    }) wp_addToSuperview:content];

    _ratingDotView = [({
        UIView *ratingDotView = [[UIView alloc] init];
        ratingDotView.layer.cornerRadius = 5.0;
        //ratingDotView.backgroundColor = [UIColor colorForRating:self.rating];
        ratingDotView;
    }) wp_addToSuperview:content];

    _taskCountLabel = [({
        FAKIonIcons *checkIcon = [FAKIonIcons ios7AmericanfootballOutlineIconWithSize:[WPLabeledIcon viewHeight]];
        UIImage *checkImage = [checkIcon imageWithSize:CGSizeMake([WPLabeledsIcon viewHeight], [WPLabeledIcon viewHeight])];
        WPLabeledIcon *taskCountLabel = [[WPLabeledIcon alloc] initWithText:@"Task Count" icon:checkImage];
        taskCountLabel.alpha = 0.3;
        taskCountLabel;
    }) wp_addToSuperview:content];

    _fieldReportCountLabel = [({
        FAKIonIcons *clipboardIcon = [FAKIonIcons iosArrowBackIconWithSize:[WPLabeledIcon viewHeight]];
        UIImage *clipboardImage = [clipboardIcon imageWithSize:CGSizeMake([WPLabeledIcon viewHeight], [WPLabeledIcon viewHeight])];
        WPLabeledIcon *fieldReportCountLabel = [[WPLabeledIcon alloc] initWithText:@"Field Report Count" icon:clipboardImage];
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

#pragma mark - Public Methods

+ (CGFloat)cellHeight { return CELL_HEIGHT; }

@end
