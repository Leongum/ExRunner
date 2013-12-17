//
//  RORTrainingMainViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-11-4.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORTrainingMainViewController.h"

@interface RORTrainingMainViewController ()

@end

@implementation RORTrainingMainViewController

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
    bookletButtonFrame = self.bookletButton.frame;
    traineeButtonFrame = self.TraineeButton.frame;
}

-(void)viewWillAppear:(BOOL)animated{
    [self initLayout];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:todoCellIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)initLayout{
    planNext = [RORPlanService fetchUserRunningPlanHistory];
    
    if (planNext){
        self.currentPlanView.alpha = 1;
        self.trainingMainBg.alpha = 1;
        self.giveUpButton.alpha = 1;
        
        self.bookletButton.frame = bookletButtonFrame;
        self.TraineeButton.frame = traineeButtonFrame;
        
        Plan *thisPlan = planNext.planInfo;
        contentList = thisPlan.missionList;
        historyList = [RORPlanService fetchUserPlanHistoryDetails:planNext.planRunUuid].runHistoryList;
        
        self.TrainingNameLabel.text = thisPlan.planName;
        int totalMissions = thisPlan.totalMissions.integerValue;
        int remainingMissions = planNext.history.remainingMissions.integerValue;
        self.process.text = [NSString stringWithFormat:@"%d/%d", totalMissions-remainingMissions, totalMissions];
        self.trainingIdLabel.text = [NSString stringWithFormat:@"训练编号：%@",planNext.planId];
    } else {
        self.currentPlanView.alpha = 0;
        self.trainingMainBg.alpha = 0;
        self.giveUpButton.alpha = 0;
        
        self.bookletButton.frame = self.currentPlanView.frame;
        self.TraineeButton.frame = CGRectMake(self.currentPlanView.frame.origin.x, self.TraineeButton.frame.origin.y, self.currentPlanView.frame.size.width, self.TraineeButton.frame.size.height);
    }
    [self initTraineeButton];
}

-(void)initTraineeButton{
    NSDictionary *dict = [RORUserUtils getUserInfoPList];
    NSNumber *fixonUserId = [RORDBCommon getNumberFromId:[dict objectForKey:@"TrainingFixonUserId"]];
    if (fixonUserId && fixonUserId.integerValue>0) {
        Plan_Run_History *fixonPlanRunHistory = [RORPlanService getUserLastUpdatePlan:fixonUserId];
        [self.TraineeButton setTitle:[NSString stringWithFormat:@"%@    %d/%d", fixonPlanRunHistory.nickName/*,  fixonPlanRunHistory.planName*/, fixonPlanRunHistory.totalMissions.integerValue - fixonPlanRunHistory.remainingMissions.integerValue,
                                      fixonPlanRunHistory.totalMissions.integerValue] forState:UIControlStateNormal];
    } else {
        [self.TraineeButton setTitle:@"找个好榜样" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    UIViewController *viewController =  [storyboard instantiateViewControllerWithIdentifier:@"TrainingRunViewController"];
    
    if ([viewController respondsToSelector:@selector(setPlanNext:)]){
        [viewController setValue:planNext forKey:@"planNext"];
    }
    if ([viewController respondsToSelector:@selector(setThisMission:)]){
        [viewController setValue:planNext.nextMission forKey:@"thisMission"];
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setPlanNext:)]){
        [destination setValue:planNext forKey:@"planNext"];
    }
    if ([destination respondsToSelector:@selector(setThisMission:)]){
        [destination setValue:planNext.nextMission forKey:@"thisMission"];
    }
}

- (IBAction)cancelCurrentTraining:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"放弃训练" message:@"确定放弃执行当前训练计划吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }else if(buttonIndex == 1){
        [RORPlanService cancelCurrentPlan:planNext.planRunUuid];
        [self initLayout];
    }
}

- (IBAction)gotoDetailPageAction:(id)sender {
    UIViewController *viewController;
    Plan *thisPlan = planNext.planInfo;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TrainingStoryboard" bundle:[NSBundle mainBundle]];
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
    if ([viewController respondsToSelector:@selector(setDelegate:)]){
        [viewController setValue:self forKey:@"delegate"];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)traineeButtonAction:(id)sender {
    if ([RORUserUtils getUserId].integerValue>0)
        [self performSegueWithIdentifier:@"pushToTraineePage" sender:self];
    else
        [self sendAlart:@"请先登录"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return planNext.planInfo.totalMissions.integerValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
//    Mission *thisMission = [contentList objectAtIndex:indexPath.row];
//    if (thisMission.missionId){
        //    }
    if (indexPath.row<historyList.count){
        static NSString *CellIdentifier = @"doneCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        User_Running_History *h = [historyList objectAtIndex:indexPath.row];
        UILabel *didTimeLabel = (UILabel *)[cell viewWithTag:101];
        didTimeLabel.text = [RORUtils transSecondToStandardFormat:h.duration.doubleValue];
        UILabel *didDistanceLabel = (UILabel *)[cell viewWithTag:102];
        didDistanceLabel.text = [RORUtils outputDistance:h.distance.doubleValue];
    } else if (indexPath.row==historyList.count){
        static NSString *CellIdentifier = @"thisCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        //提示此次训练还剩几天，后面考虑用一个CustomView实现
        UILabel *leftDays = (UILabel *)[cell viewWithTag:105];
        NSLog(@"left days:%.0f", [planNext.startTime timeIntervalSinceNow]);
        leftDays.text = [NSString stringWithFormat:@"%.0f", [RORPlanService getCycleTimeofPlanNext:planNext]+[planNext.startTime timeIntervalSinceNow]/3600/24];
        
        todoCellIndex = indexPath;
    } else {
        static NSString *CellIdentifier = @"todoCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UILabel *sequenceLabel = (UILabel *)[cell viewWithTag:100];
        sequenceLabel.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
        
        return cell;
    }
    UILabel *sequenceLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *requireTimeLabel = (UILabel *)[cell viewWithTag:103];
    
    Mission *thisMission;
    if (planNext.planInfo.planType.integerValue == ComplexTask)
        thisMission = [contentList objectAtIndex:indexPath.row];
    else
        thisMission = [contentList objectAtIndex:0];
    
    sequenceLabel.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
    if (thisMission.missionDistance.doubleValue < 1){
        requireTimeLabel.text = [NSString stringWithFormat:@"计时跑：%@",[RORUtils transSecondToStandardFormat:thisMission.missionTime.doubleValue]];
    } else {
        requireTimeLabel.text = [NSString stringWithFormat:@"定距跑：%gkm",thisMission.missionDistance.doubleValue/1000];
    }
    
//    requireDistanceLabel.text = [RORUtils outputDistance:thisMission.missionDistance.doubleValue];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<historyList.count){
        User_Running_History *h = [historyList objectAtIndex:indexPath.row];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
        UIViewController *viewController =  [storyboard instantiateViewControllerWithIdentifier:@"historyDetailViewController"];
        [viewController setValue:h forKey:@"record"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    return;
}


@end
