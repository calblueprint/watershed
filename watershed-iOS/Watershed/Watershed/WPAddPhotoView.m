//
//  WPAddPhotoView.m
//  Watershed
//
//  Created by Jordeen Chang on 11/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPAddPhotoView.h"
#import "UIExtensions.h"

@interface WPAddPhotoView()

@property (nonatomic) WPAddPhotoViewController *parentController;

@end

@implementation WPAddPhotoView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubviews];
        [self updateConstraints];
        [self setUpActions];
    }
    return self;
}

- (instancetype)initWithAddPhotoViewController:(WPAddPhotoViewController *)addPhotoViewController {
    self = [super init];
    self.parentController = addPhotoViewController;
    if (self) {
        [self createSubviews];
        [self updateConstraints];
        [self setUpActions];
    }
    return self;
}

- (void)createSubviews {
    _takePhotoButton = [({
        UIButton *take = [[UIButton alloc] init];
        take.backgroundColor = [UIColor wp_darkBlue];
        take;
    }) wp_addToSuperview:self];

    _selectPhotoButton = [({
        UIButton *select = [[UIButton alloc] init];
        select.backgroundColor = [UIColor wp_darkBlue];
        select;
    }) wp_addToSuperview:self];
    
    _selectedImageView = [({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor redColor];
        imageView;
    }) wp_addToSuperview:self];
}

- (void)setUpActions {
    [_takePhotoButton setTitle:@"Click me to take picture" forState:UIControlStateNormal];
    [_selectPhotoButton setTitle:@"Click YOYOYOYOYO" forState:UIControlStateNormal];
}

- (void)updateConstraints {
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(topMargin));
        make.height.equalTo(@300);
        make.leading.equalTo(@(standardMargin));
        make.trailing.equalTo(@(-standardMargin));
    }];
    
    [self.takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectedImageView.mas_bottom).with.offset(standardMargin);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@50);
        make.width.equalTo(@200);
    }];
    
    [self.selectPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.takePhotoButton.mas_bottom).with.offset(standardMargin);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@50);
        make.width.equalTo(@200);
    }];
    
    [super updateConstraints];
}




@end
