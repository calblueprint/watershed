//
//  WPAllTasksTableViewController.m
//  Watershed
//
//  Created by Jordeen Chang on 10/14/14.
//  Copyright (c) 2014 Blueprint. All rights reserved.
//

#import "WPTableViewCell.h"
#import "UIColor+WPColors.h"
#import "WPAllTasksTableViewController.h"
#import "WPAllTasksTableView.h"

@interface WPAllTasksTableViewController ()

@property (nonatomic) WPAllTasksTableView *tableView;

@end

static NSString *CellIdentifier = @"CellTaskIdentifier";

@implementation WPAllTasksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tasks = @[
               @{@"Task": @"Water Tree", @"Description": @"Please", @"DueDate": @"05/11"},
               @{@"Task": @"Prune Tree", @"Description": @"Pretty please", @"DueDate": @"05/10"},
               @{@"Task": @"Keep Tree Alive", @"Description": @"Cherry on top"},
               @{@"Task": @"Start Tree", @"Description": @"Dig hole", @"DueDate": @"05/12"},
               @{@"Task": @"Put Tree in Hole", @"Description": @"Place it in", @"DueDate": @"05/12"}
               ];
    self.tableView = [[WPAllTasksTableView alloc] initWithFrame:CGRectMake(0, 70, 320, 490)];
    [self.tableView registerClass:[WPTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    // must set delegate & dataSource, otherwise the the table will be empty and not responsive
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    
    // add to canvas
//    [self.view addSubview:self.tableView];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tasks count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.section == 1 && indexPath.row == 1) {
    //        return 100;
    //    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *rowData = self.tasks[indexPath.row];
    cell.title = rowData[@"Task"];
    cell.taskDescription = rowData[@"Description"];
    cell.dueDate = rowData[@"DueDate"];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
