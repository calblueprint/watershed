//
//  WPFieldReportView.h
//  Watershed
//
//  Created by Andrew Millman on 11/9/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPView.h"

@interface WPFieldReportView : WPView

@property (nonatomic) UIImageView *reportImageView;
@property (nonatomic) UILabel *ratingNumberLabel;
@property (nonatomic) UIImageView *userImageView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *userLabel;
@property (nonatomic) UILabel *descriptionLabel;

- (void)showBubbles;

@end
