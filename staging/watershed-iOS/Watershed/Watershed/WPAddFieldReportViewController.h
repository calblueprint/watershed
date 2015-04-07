//
//  WPAddFieldReportViewController.h
//  Watershed
//
//  Created by Jordeen Chang on 10/29/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPCreateMiniSiteImageTableViewCell.h"

@interface WPAddFieldReportViewController : UIViewController<
    UITableViewDataSource,
    UITableViewDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UIActionSheetDelegate,
    UITextViewDelegate>

@property (nonatomic) WPCreateMiniSiteImageTableViewCell *imageInputCell;


@end
