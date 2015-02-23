//
//  WPTermsView.h
//  Watershed
//
//  Created by Andrew Millman on 1/24/15.
//  Copyright (c) 2015 Blueprint. All rights reserved.
//

#import "WPView.h"

@interface WPTermsView : WPView

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UILabel *termsLabel;
@property (nonatomic) UILabel *termsInfoLabel;
@property (nonatomic) UILabel *privacyLabel;
@property (nonatomic) UILabel *privacyInfoLabel;

@end