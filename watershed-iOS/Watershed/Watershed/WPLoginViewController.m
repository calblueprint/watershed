//
//  LoginViewController.m
//  Watershed
//
//  Created by Andrew on 9/28/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPLoginViewController.h"
#import "WPLoginView.h"

@interface WPLoginViewController ()

@end

@implementation WPLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)loadView
{
    self.view = [[WPLoginView alloc] init];
}


@end
