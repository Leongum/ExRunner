//
//  RORTraineesViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-11-5.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORTraineesViewController.h"
#import "FTAnimation.h"

@interface RORTraineesViewController ()

@end

@implementation RORTraineesViewController

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
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showTraineesAction:(id)sender {
    
    double duration = 0.3;
    if (self.tableView.alpha>0) {
        [self.tableView fold:duration delegate:self startSelector:nil stopSelector:@selector(hideTableView)];
    } else {
        self.tableView.alpha = 1;
        [self.tableView expand:duration delegate:self startSelector:@selector(showTableView) stopSelector:nil];
    }

    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

-(void)showTableView{
    self.tableView.alpha = 1;
}

-(void)hideTableView{
    self.tableView.alpha = 0;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"traineeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *label = (UILabel*)[cell viewWithTag:100];
    label.text = [NSString stringWithFormat:@"%d",indexPath.row];
    return cell;
}



@end
