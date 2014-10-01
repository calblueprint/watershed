//
//  WPTasksListViewController.m
//  
//
//  Created by Jordeen Chang on 9/28/14.
//
//

#import "WPTasksListViewController.h"
#import "WPTasksListView.h"

@interface WPTasksListViewController ()

@property (nonatomic) WPTasksListView *view;

@end

@implementation WPTasksListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)loadView {
    self.view = [[WPTasksListView alloc] init];
}

@end
