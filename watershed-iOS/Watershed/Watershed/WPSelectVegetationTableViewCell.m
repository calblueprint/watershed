//
//  WPSelectVegetationTableViewCell.m
//  Watershed
//
//  Created by Andrew Millman on 12/15/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPSelectVegetationTableViewCell.h"

@interface WPSelectVegetationTableViewCell ()
@property (nonatomic) UIView *radioButton;
<<<<<<< HEAD
@property (nonatomic) UIImageView *checkImageView;
@property (nonatomic) UIView *separatorView;
=======
>>>>>>> Add custom radio buttons for vegetation cells
@end

@implementation WPSelectVegetationTableViewCell

<<<<<<< HEAD
const static float CELL_HEIGHT = 60.0f;
const static float RADIO_BUTTON_SIZE = 30.0f;
const static float CHECK_SIZE = RADIO_BUTTON_SIZE * 3 / 5;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
=======
const static float CELL_HEIGHT = 50.0f;
const static float RADIO_BUTTON_SIZE = 25.0f;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
>>>>>>> Add custom radio buttons for vegetation cells
        [self createSubviews];
        [self updateConstraints];
    }
    return self;
}

- (void)createSubviews {
    _radioButton = [({
        UIView *button = [[UIView alloc] init];
        button.layer.cornerRadius = RADIO_BUTTON_SIZE / 2;
        button.clipsToBounds = YES;
<<<<<<< HEAD
        button.backgroundColor = [UIColor whiteColor];
        button.layer.borderColor = [UIColor grayColor].CGColor;
        button.layer.borderWidth = 2.0;
        button.alpha = 0.3;
        button;
    }) wp_addToSuperview:self];
    
    _checkImageView = [({
        FAKFontAwesome *checkIcon = [FAKFontAwesome checkIconWithSize:CHECK_SIZE];
        UIImage *checkImage = [checkIcon imageWithSize:CGSizeMake(CHECK_SIZE, CHECK_SIZE)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:checkImage];
        [imageView setFrame:CGRectMake((RADIO_BUTTON_SIZE - CHECK_SIZE) / 2, (RADIO_BUTTON_SIZE - CHECK_SIZE) / 2, CHECK_SIZE, CHECK_SIZE)];
        imageView.alpha = 0;
        imageView;
    }) wp_addToSuperview:self.radioButton];
    
    _separatorView = [({
        UIView *separator = [[UIView alloc] init];
        separator.backgroundColor = [UIColor grayColor];
        separator.alpha = 0.3;
        separator;
    }) wp_addToSuperview:self];
}

- (void)updateConstraints {
    
=======
        button.layer.borderColor = [UIColor grayColor].CGColor;
        button.backgroundColor = [UIColor grayColor];
        button;
    }) wp_addToSuperview:self];
}

- (void)updateConstraints {

>>>>>>> Add custom radio buttons for vegetation cells
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
<<<<<<< HEAD
    
=======

>>>>>>> Add custom radio buttons for vegetation cells
    [self.radioButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-standardMargin));
        make.width.equalTo(@(RADIO_BUTTON_SIZE));
        make.height.equalTo(@(RADIO_BUTTON_SIZE));
        make.centerY.equalTo(self.mas_centerY);
    }];
<<<<<<< HEAD
    
    [self.separatorView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(0.5));
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
=======

>>>>>>> Add custom radio buttons for vegetation cells
    [super updateConstraints];
}

#pragma mark - Public Methods

+ (CGFloat)cellHeight {
    return CELL_HEIGHT;
}

<<<<<<< HEAD
#pragma mark - UI Modifications

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.backgroundColor = [UIColor wp_lightBlue];
        self.textLabel.textColor = [UIColor whiteColor];
        self.radioButton.layer.borderColor = [UIColor clearColor].CGColor;
        self.radioButton.alpha = 1;
        self.checkImageView.alpha = 1;
        self.separatorView.backgroundColor = [UIColor whiteColor];
        self.separatorView.alpha = 0.7;
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundColor = [UIColor clearColor];
            self.textLabel.textColor = [UIColor blackColor];
            self.radioButton.layer.borderColor = [UIColor grayColor].CGColor;
            self.radioButton.alpha = 0.3;
            self.checkImageView.alpha = 0;
            self.separatorView.backgroundColor = [UIColor grayColor];
            self.separatorView.alpha = 0.3;
=======
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected) {
        self.backgroundColor = [UIColor wp_lightBlue];
        self.textLabel.textColor = [UIColor whiteColor];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.backgroundColor = [UIColor clearColor];
            self.textLabel.textColor = [UIColor blackColor];
>>>>>>> Add custom radio buttons for vegetation cells
        }];
    }
}


@end
