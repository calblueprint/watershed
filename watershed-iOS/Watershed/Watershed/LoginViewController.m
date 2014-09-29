//
//  LoginViewController.m
//  Watershed
//
//  Created by Andrew on 9/28/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:129.0/255.0
                                                green:180.0/255.0
                                                 blue:222.0/255.0
                                                alpha:1.0];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [self addEmailButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Add Views

- (void)addEmailButton
{
    CGRect emailButtonFrame = CGRectMake(10, self.view.frame.size.height - 60, self.view.frame.size.width - 20, 50);
    UIButton *emailButton = [[UIButton alloc] initWithFrame:emailButtonFrame];
    emailButton.backgroundColor = [UIColor colorWithRed:1.0
                                                  green:1.0
                                                   blue:1.0
                                                  alpha:0.5];
    [emailButton setTitle:@"Sign in with Email" forState:UIControlStateNormal];
    emailButton.layer.cornerRadius = 5.0;
    
    UIImageView *emailIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"EmailIcon"]];
    [emailIconView setFrame:CGRectMake(10, 10, 30, 30)];
    emailIconView.contentMode = UIViewContentModeScaleAspectFit;
    
    [emailButton addSubview:emailIconView];
    
    [self.view addSubview:emailButton];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
