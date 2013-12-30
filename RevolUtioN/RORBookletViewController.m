
//
//  RORBookletViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-11-5.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORBookletViewController.h"
#import "Animations.h"
#import "FTAnimation.h"

@interface RORBookletViewController ()

@end

@implementation RORBookletViewController
@synthesize planNext, historyList;
@synthesize delegate;
@synthesize needRefresh;

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
    //****************
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    storyboard = [UIStoryboard storyboardWithName:@"TrainingStoryboard" bundle:[NSBundle mainBundle]];
    searchViewController =  [storyboard instantiateViewControllerWithIdentifier:@"searchViewController"];
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    frame.origin.y = frame.size.height*3/23 -frame.size.height;

    searchViewController.view.frame = frame;
    searchViewController.delegate = self;
    
    [self addChildViewController:searchViewController];
    [self.view addSubview:searchViewController.view];
    [searchViewController didMoveToParentViewController:self];
    self.searchTrainingView = searchViewController.view;
    
    [self.view bringSubviewToFront:self.backButton];
    [self.view bringSubviewToFront:self.editButton];

}

-(void)viewWillAppear:(BOOL)animated{

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //===============
    [self startIndicator:self];
    NSNumber *userId = [RORUserUtils getUserId];
    contentList = [RORPlanService fetchPlanCollect:userId];
    historyList = [RORPlanService fetchUserPlanHistoryList:userId];
    [self.tableView reloadData];
    
    [self endIndicator:self];
    //****************
    
    if (contentList.count==0 && !searchViewController.expanded){
//        [searchViewController expandAction:self];
        RORIntroCoverView *introCoverView = [[RORIntroCoverView alloc]initWithFrame:self.view.frame andImage:[UIImage imageNamed:@"introBookletPage.png"]];
        [self.view addSubview:introCoverView];
    }
}

-(IBAction)reloadTableViewAction:(id)sender{
    [self viewWillAppear:YES];
    [self.tableViewBg pop:0.5 delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) checkIfDone:(NSNumber *)planId{
    for (Plan_Run_History *history in historyList){
        if (history.planId == planId && history.historyStatus.integerValue == HistoryStatusFinished)
            return YES;
    }
    return NO;
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
        [destination setValue:plan forKey:@"plan"];
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
    
    Plan *thisPlan = [contentList objectAtIndex:indexPath.row];
    
    int status = 0;
    if (thisPlan.planId.integerValue == planNext.planId.integerValue){
        static NSString *CellIdentifier = @"doingCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        status = 1;
    } else if ([self checkIfDone:thisPlan.planId]){
        static NSString *CellIdentifier = @"didCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        status = 0;
    } else {
        static NSString *CellIdentifier = @"todoCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        status = 2;
    }
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.text = thisPlan.planName;
//    UILabel *statusLabel = (UILabel *)[cell viewWithTag:103];
//    switch (status) {
//        case 0:
//            statusLabel.text = @"已完成";
//            break;
//        case 1:
//            statusLabel.text = @"执行中";
//            break;
//        case 2:
//            statusLabel.text = @"关注中";
//        default:
//            break;
//    }
    UIImageView *certified = (UIImageView *)[cell viewWithTag:102];
    certified.alpha = thisPlan.sharedPlan.integerValue == SharedPlanSystem;
    UILabel *planIdLabel = (UILabel *)[cell viewWithTag:101];
    planIdLabel.text = [NSString stringWithFormat:@"编号：%@", thisPlan.planId];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Plan *thisPlan = [contentList objectAtIndex:indexPath.row];
    UIViewController *viewController;
    switch (thisPlan.planType.integerValue) {
        case PlanTypeEasy:{
            viewController =  [storyboard instantiateViewControllerWithIdentifier:@"SimpleTrainingViewController"];
            break;
        }
        case PlanTypeComplex:{
            viewController =  [storyboard instantiateViewControllerWithIdentifier:@"AdvancedTrainingViewController"];
            break;
        }
        default:
            break;
    }
    if ([viewController respondsToSelector:@selector(setPlan:)]){
        [viewController setValue:thisPlan forKey:@"plan"];
    }
    if ([viewController respondsToSelector:@selector(setPlanNext:)]){
        [viewController setValue:planNext forKey:@"planNext"];
    }
    if ([viewController respondsToSelector:@selector(setDelegate:)]){
        [viewController setValue:self forKey:@"delegate"];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//更改删除按钮
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Plan *thisPlan = [contentList objectAtIndex:indexPath.row];
    NSNumber *userId = [RORUserUtils getUserId];
    Plan_Collect *planCollect = [RORPlanService fetchPlanCollect:userId withPlanId:thisPlan.planId withContext:YES];
    planCollect.collectStatus = [NSNumber numberWithInt:CollectStatusNotCollected];
    [RORPlanService updatePlanCollect:planCollect];
    
    [contentList removeObject:thisPlan];
    [tableView reloadData];
}
@end
