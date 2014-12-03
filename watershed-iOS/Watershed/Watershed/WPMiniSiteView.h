//
//  WPMiniSiteView.h
//  Watershed
//
//  Created by Andrew Millman on 11/2/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPView.h"
#import "WPMiniSite.h"

@interface WPMiniSiteView : WPView

@property (nonatomic) UIImageView *coverPhotoView;
@property (nonatomic) UIImage *originalCoverPhoto;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *descriptionLabel;
@property (nonatomic) WPLabeledIcon *addressLabel;
@property (nonatomic) WPLabeledIcon *vegetationListLabel;
@property (nonatomic) WPLabeledIcon *currentTaskLabel;
@property (nonatomic) WPLabeledIcon *fieldReportCountLabel;
@property (nonatomic) UITableView *fieldReportTableView;

- (void)updateTableViewHeight:(NSInteger)cellCount;
- (void)configureWithMiniSite:(WPMiniSite *)miniSite;

@end
