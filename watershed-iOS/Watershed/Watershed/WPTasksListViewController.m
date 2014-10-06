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
//@property (nonatomic) UIView *view;

//@property (nonatomic) NSArray *colors;

@end

@implementation WPTasksListViewController {
    UITableView *tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    _colors = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
    self.view = [[WPTasksListView alloc] init];
    
    tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
//    tableView.frame = CGRectMake(0, 0, 200, 200);
    
    // must set delegate & dataSource, otherwise the the table will be empty and not responsive
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.backgroundColor = [UIColor cyanColor];
    
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));

    // add to canvas
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view.
}

- (void)loadView {
    self.view = [[WPTasksListView alloc] init];
}

- (NSInteger)tableView:(UITableView *)tasksTableView numberOfRowsInSection:(NSInteger)section
{
//    NSString *color = [self tableView:tableView titleForHeaderInSection:section];
//    return [[self.colors valueForKey:color] count];
    return 1;
}

- (NSInteger)numberOfRowsInTableView:(UITableView *)tasksTableView {
//    return [_colors count];
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tasksTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tasksTableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    cell.textLabel.text = @"Testing";
    return cell;
}
@end
