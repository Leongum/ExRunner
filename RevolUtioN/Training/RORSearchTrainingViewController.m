//
//  RORSearchTrainingViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-11-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORSearchTrainingViewController.h"
#import "FTAnimation.h"

@interface RORSearchTrainingViewController ()

@end

@implementation RORSearchTrainingViewController

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
    self.backButton.alpha = 0;
    expanded = NO;
    isTableEmpty = YES;
    currentPages = 0;
    noMoreData = NO;
    contentList = [[NSMutableArray alloc]init];
    [self loadTableViewData:currentPages++];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)expandAction:(id)sender {
    CGRect f = self.view.frame;
    
    if (!expanded) {
        expanded = YES;
        searchViewTop = f.origin.y;
        [self.view moveUp:0.5 length:-searchViewTop delegate:self];
        self.view.frame = CGRectMake(f.origin.x, 0, f.size.width, f.size.height);
    } else {
        expanded = NO;
        [self.view moveUp:0.5 length:searchViewTop delegate:self];
        self.view.frame = CGRectMake(f.origin.x, searchViewTop, f.size.width, f.size.height);
    }
}

-(void)loadTableViewData:(NSInteger)page{
    if (noMoreData)
        return;
    
    int count = contentList.count;
    NSArray *array = [RORPlanService getTopPlansList:[NSNumber numberWithInteger:page]];
    [contentList addObjectsFromArray:array];
    if (contentList.count-count<PLAN_PAGE_SIZE){
        noMoreData = YES;
    }
    [self.tableView reloadData];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setPlan:)]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Plan *planNoDetail = (Plan *)[contentList objectAtIndex:indexPath.row];
        Plan *plan = [RORPlanService syncPlan:planNoDetail.planId];
        NSLog(@"%d", indexPath.row);
        [destination setValue:plan forKey:@"plan"];
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return contentList.count +1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.row == contentList.count) {
        static NSString *CellIdentifier = @"moreCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
        titleLabel.text = @"目前只有这么多";
        return cell;
    }
    
    
    Plan *thisPlan = [contentList objectAtIndex:indexPath.row];
    NSNumber *planType = thisPlan.planType;
    

    if (planType.integerValue == PLAN_TYPE_SIMPLE){
        static NSString *CellIdentifier = @"simpleTrainingCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UILabel *timesLabel = (UILabel *)[cell viewWithTag:CELLTAG_TIMES];

        timesLabel.text = [NSString stringWithFormat:@"%@次/%@天",thisPlan.totalMissions, thisPlan.durationLast];
        
    } else if (planType.integerValue == PLAN_TYPE_ADVANCED){
        static NSString *CellIdentifier = @"advTrainingCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        for (NSNumber *missionID in thisPlan.missionList){
//            Plan *detailPlan = [RORPlanService fetchPlan:missionID];
//        }
        UILabel *timesLabel = (UILabel *)[cell viewWithTag:CELLTAG_TIMES];
        timesLabel.text = [NSString stringWithFormat:@"%@次",thisPlan.totalMissions];

    }
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:CELLTAG_TITLE];
    titleLabel.text = thisPlan.planName;

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == contentList.count){
        [self loadTableViewData:currentPages++];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<contentList.count)
        return 77;
    return 50;
}

@end
