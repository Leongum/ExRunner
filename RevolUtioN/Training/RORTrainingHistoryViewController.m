//
//  RORTrainingHistoryViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-12-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORTrainingHistoryViewController.h"

@interface RORTrainingHistoryViewController ()

@end

@implementation RORTrainingHistoryViewController

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
    contentList = [[NSMutableArray alloc]init];
    NSArray *trainingAll = [RORPlanService fetchUserPlanHistoryList:[RORUserUtils getUserId]];

    for (Plan_Run_History *history in trainingAll){
        if (history.historyStatus.integerValue == HistoryStatusFinished || history.historyStatus.integerValue == HistoryStatusExecute)
            [contentList addObject:[RORPlanService fetchUserPlanHistoryDetails:history.planRunUuid]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setThisHistory:)]){
        UITableViewCell *thisCell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:thisCell];
        Plan_Run_History *planHistory = (Plan_Run_History*)[contentList objectAtIndex:indexPath.row];
        planHistory = [RORPlanService fetchUserPlanHistoryDetails:planHistory.planRunUuid];
        [destination setValue:planHistory forKey:@"thisHistory"];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    Plan_Run_History *thisPlan = [contentList objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"planCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.text = thisPlan.planName;
    UILabel *planIdLabel = (UILabel *)[cell viewWithTag:101];
    planIdLabel.text = [NSString stringWithFormat:@"编号：%@", thisPlan.planId];
    
    return cell;
}

@end
