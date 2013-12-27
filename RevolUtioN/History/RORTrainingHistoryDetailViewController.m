//
//  RORTrainingHistoryDetailViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-12-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORTrainingHistoryDetailViewController.h"

@interface RORTrainingHistoryDetailViewController ()

@end

@implementation RORTrainingHistoryDetailViewController
@synthesize thisHistory;

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
    thisPlan = [RORPlanService fetchPlan:thisHistory.planId];
    
    self.trainingNameLabel.text = thisHistory.planName;
    
    contentList = thisHistory.runHistoryList;
}

-(void)viewWillAppear:(BOOL)animated{
    [self calculateTotle];
    [self fillTotle:self.totle2Fill];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)getShareImage:(id)sender{
    RORTrainingHistoryShareView *testView = [[RORTrainingHistoryShareView alloc]init];
    CGRect totleFrame = self.totle2Fill.frame;
    //add total
    self.totle2Fill.frame = CGRectMake(totleFrame.origin.x, totleFrame.origin.y, 266, totleFrame.size.height);
    [testView add:[[UIImageView alloc]initWithImage:[RORUtils getImageFromView:self.totle2Fill]]];
    self.totle2Fill.frame = totleFrame;
    //add details
    self.view2Fill.alpha = 1;
    for (int i=0; i<contentList.count; i++){
        [self fillView:self.view2Fill byObjAtIndex:i];
        UIImage *image =[RORUtils getImageFromView:self.view2Fill];
        UIView *iv = [[UIImageView alloc]initWithImage:image];
        iv.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [testView add:iv];
    }
    self.view2Fill.alpha = 0;
//    [self.view addSubview:testView];
//    [testView removeFromSuperview];
    [RORUtils popShareCoverViewFor:self withImage:[testView getImage] title:@"分享这个页面" andMessage:@"Training plan share" animated:YES];
}


-(void)fillView:(UIView *)thisView byObjAtIndex:(NSInteger)index {
    User_Running_History *h = [contentList objectAtIndex:index];
    
    Mission *thisMission;
    if (thisPlan.planType.integerValue == ComplexTask)
        thisMission = [thisPlan.missionList objectAtIndex:index];
    else
        thisMission = [thisPlan.missionList objectAtIndex:0];
    
    UILabel *didTimeLabel = (UILabel *)[thisView viewWithTag:101];
    didTimeLabel.text = [NSString stringWithFormat:@"用时: %@",[RORUtils transSecondToStandardFormat:h.duration.doubleValue]];
    UILabel *didDistanceLabel = (UILabel *)[thisView viewWithTag:102];
    didDistanceLabel.text = [NSString stringWithFormat:@"里程: %@", [RORUtils outputDistance:h.distance.doubleValue]];
    
    UILabel *sequenceLabel = (UILabel *)[thisView viewWithTag:100];
    UILabel *requireTimeLabel = (UILabel *)[thisView viewWithTag:103];
    sequenceLabel.text = [NSString stringWithFormat:@"第%d天", (int)([h.missionDate timeIntervalSinceDate:thisHistory.startTime]/3600/24)];
    if (thisMission.missionDistance.doubleValue < 1){
        requireTimeLabel.text = [NSString stringWithFormat:@"计时跑：%@",[RORUtils transSecondToStandardFormat:thisMission.missionTime.doubleValue]];
    } else {
        requireTimeLabel.text = [NSString stringWithFormat:@"定距跑：%gkm",thisMission.missionDistance.doubleValue/1000];
    }

    UILabel *reqSpeedLabel = (UILabel *)[thisView viewWithTag:104];
    UILabel *speedLabel = (UILabel *)[thisView viewWithTag:105];
    reqSpeedLabel.text = [NSString stringWithFormat:@"%@-%@",[RORUserUtils formatedSpeed:thisMission.suggestionMaxSpeed.doubleValue],[RORUserUtils formatedSpeed:thisMission.suggestionMinSpeed.doubleValue]];
    speedLabel.text = [RORUserUtils formatedSpeed:h.avgSpeed.doubleValue];
}

-(void)calculateTotle{
    double totleSpeed=0;
    totleDistance = 0;
    totleDuration = 0;
    avgSpeed = 0;
    for (User_Running_History *h in contentList){
        totleDistance+=h.distance.doubleValue;
        totleDuration+=h.duration.doubleValue;
        totleSpeed+=h.avgSpeed.doubleValue;
    }
    if (contentList.count>0)
        avgSpeed = totleSpeed/contentList.count;
}

-(void)fillTotle:(UIView *)thisView{
    UILabel *planNameLabel = (UILabel *)[thisView viewWithTag:100];
    UILabel *planIdLabel = (UILabel *)[thisView viewWithTag:101];
    UILabel *processLabel = (UILabel *)[thisView viewWithTag:102];
    UILabel *totleDistanceLabel = (UILabel *)[thisView viewWithTag:103];
    UILabel *totleDurationLabel = (UILabel *)[thisView viewWithTag:104];
    UILabel *avgSpeedLabel = (UILabel *)[thisView viewWithTag:105];
    UILabel *dateLabel = (UILabel *)[thisView viewWithTag:106];
    
    planNameLabel.text = thisPlan.planName;
    planIdLabel.text = [NSString stringWithFormat:@"编号：%@", thisPlan.planId];
    
    processLabel.text = [NSString stringWithFormat:@"%d/%@", thisPlan.totalMissions.integerValue- thisHistory.remainingMissions.integerValue, thisPlan.totalMissions];
    totleDistanceLabel.text = [RORUtils outputDistance:totleDistance];
    totleDurationLabel.text = [RORUtils transSecondToStandardFormat:totleDuration];
    avgSpeedLabel.text = [RORUserUtils formatedSpeed:avgSpeed];
    
    NSDateFormatter *formattter = [[NSDateFormatter alloc] init];
    [formattter setDateFormat:@"yyyy/MM/dd"];
    if (thisHistory.historyStatus.integerValue == HistoryStatusFinished)
        dateLabel.text = [NSString stringWithFormat:@"%@ - %@", [formattter stringFromDate:thisHistory.startTime], [formattter stringFromDate:thisHistory.endTime]];
    else
        dateLabel.text = [NSString stringWithFormat:@"%@ - 今天", [formattter stringFromDate:thisHistory.startTime]];
    
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
    
    //    Mission *thisMission = [contentList objectAtIndex:indexPath.row];
    //    if (thisMission.missionId){
    //    }
        static NSString *CellIdentifier = @"doneCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self fillView:cell byObjAtIndex:indexPath.row];
    
    //    requireDistanceLabel.text = [RORUtils outputDistance:thisMission.missionDistance.doubleValue];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    User_Running_History *h = [contentList objectAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    UIViewController *viewController =  [storyboard instantiateViewControllerWithIdentifier:@"historyDetailViewController"];
    [viewController setValue:h forKey:@"record"];
    [self.navigationController pushViewController:viewController animated:YES];
    
    return;
}

@end
