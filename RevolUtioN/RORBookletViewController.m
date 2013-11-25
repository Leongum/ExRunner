
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
    
    storyboard = [UIStoryboard storyboardWithName:@"TrainingStoryboard" bundle:[NSBundle mainBundle]];
    searchViewController =  [storyboard instantiateViewControllerWithIdentifier:@"searchViewController"];
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    frame.origin.y = 55-frame.size.height;
    searchViewController.view.frame = frame;
    
    [self addChildViewController:searchViewController];
    [self.view addSubview:searchViewController.view];
    [searchViewController didMoveToParentViewController:self];
    self.searchTrainingView = searchViewController.view;
    
    [self.view bringSubviewToFront:self.backButton];
    [self.view bringSubviewToFront:self.editButton];
    
    NSNumber *userId = [RORUserUtils getUserId];
    contentList = [RORPlanService fetchPlanCollect:userId];
    historyList = [RORPlanService fetchUserPlanHistoryList:userId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editButtonAction:(id)sender {
    if (isEditing){
        isEditing = NO;
        [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    } else {
        isEditing = YES;
        [self.editButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

-(BOOL) checkIfDone:(NSNumber *)planId{
    for (Plan_Run_History *history in historyList){
        if (history.planId == planId)
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
    UILabel *statusLabel = (UILabel *)[cell viewWithTag:103];
    switch (status) {
        case 0:
            statusLabel.text = @"已完成";
            break;
        case 1:
            statusLabel.text = @"执行中";
            break;
        case 2:
            statusLabel.text = @"关注中";
        default:
            break;
    }
    
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
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
