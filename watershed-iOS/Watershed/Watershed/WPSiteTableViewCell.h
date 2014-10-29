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

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
               name:(NSString *)name
              image:(UIImage *)image
      miniSiteCount:(NSInteger)miniSiteCount;

- (void)updatePhotoPosition:(NSNumber *)contentOffset;

+ (CGFloat)cellHeight;

@end
