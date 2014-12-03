//
//  WPSiteTableViewCell.h
//  Watershed
//
//  Created by Andrew Millman on 10/26/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPView.h"

@interface WPSiteTableViewCell : UITableViewCell

@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UIImageView *photoView;
@property (nonatomic) UILabel *miniSiteLabel;

- (void)updatePhotoPosition:(NSNumber *)contentOffset;

+ (CGFloat)cellHeight;

@end
