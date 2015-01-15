//
//  WPCreateMiniSiteImageTableViewCell.m
//  Watershed
//
//  Created by Andrew Millman on 12/11/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPCreateMiniSiteImageTableViewCell.h"

@implementation WPCreateMiniSiteImageTableViewCell


const static float CELL_HEIGHT = 80.0f;
const static float IMAGE_SIZE = CELL_HEIGHT - 2 * standardMargin;
const static float LABEL_WIDTH = 75.0f;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
        [self updateConstraints];
    }
    return self;
}

- (void)createSubviews {
    _inputLabel = [({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13.0];
        label;
    }) wp_addToSuperview:self.contentView];
    
    _imageInput = [({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.cornerRadius = 5.0f;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView;
    }) wp_addToSuperview:self.contentView];
    
    _viewImageButton = [({
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor wp_darkBlue];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
        [button setTitle:@"View Photo" forState:UIControlStateNormal];
        button.layer.cornerRadius = 3.0;
        button.alpha = 0;
        button;
    }) wp_addToSuperview:self.contentView];
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
    
    [self.inputLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(LABEL_WIDTH));
        make.height.equalTo(@44);
        make.top.equalTo(@0);
        make.leading.equalTo(@15);
    }];
    
    [self.imageInput mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(standardMargin));
        make.leading.equalTo(self.inputLabel.mas_trailing).with.offset(standardMargin);
        make.height.equalTo(@(IMAGE_SIZE));
        make.width.equalTo(@(IMAGE_SIZE));
    }];
    
    [self.viewImageButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-standardMargin));
        make.height.equalTo(@(36));
        make.width.equalTo(@(90));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [super updateConstraints];
}

#pragma mark - Public Methods

+ (CGFloat)cellHeight {
    return CELL_HEIGHT;
}

@end
