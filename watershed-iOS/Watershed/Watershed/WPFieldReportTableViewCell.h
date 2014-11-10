//
//  WPFieldReportTableViewCell.h
//  Watershed
//
//  Created by Andrew Millman on 11/3/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPView.h"

@interface WPFieldReportTableViewCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
              image:(UIImage *)image
               date:(NSString *)date
             rating:(NSInteger)rating
             urgent:(BOOL)urgent;

+ (CGFloat)cellHeight;

@end
