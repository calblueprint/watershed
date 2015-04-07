//
//  WPSiteView.h
//  Watershed
//
//  Created by Andrew Millman on 10/5/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPView.h"
#import "WPSite.h"

@interface WPSiteView : WPView

@property (nonatomic) UIImageView *coverPhotoView;
@property (nonatomic) UIImage *originalCoverPhoto;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *descriptionLabel;
@property (nonatomic) WPLabeledIcon *addressLabel;
@property (nonatomic) WPLabeledIcon *siteCountLabel;
@property (nonatomic) UIScrollView *siteScrollView;
@property (nonatomic) UITableView *miniSiteTableView;

- (void)updateTableViewHeight:(NSInteger)cellCount;
- (void)configureWithSite:(WPSite *)site;
- (void)stopIndicator;

@end
