//
//  WPMiniSiteTableViewCell.h
//  Watershed
//
//  Created by Andrew on 10/13/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPMiniSiteTableViewCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
               name:(NSString *)name
              image:(UIImage *)image
             rating:(NSInteger)rating
          taskCount:(NSInteger)taskCount
   fieldReportCount:(NSInteger)fieldReportCount;

@end
