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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)getShareImage:(id)sender{
    RORTrainingHistoryShareView *testView = [[RORTrainingHistoryShareView alloc]initWithFrame:self.view.frame];
    
    for (int i=0; i<contentList.count; i++){
        [self fillView:self.view2Fill byObjAtIndex:i];
        UIView *iv = [[UIImageView alloc]initWithImage:[RORUtils getImageFromView:self.view2Fill]];
//        iv.frame = CGRectMake(0, 0, 320, 300);
        [testView add:iv];
    }
    [self.view addSubview:testView];
    [testView removeFromSuperview];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[testView getImage]];
//    imageView.frame = CGRectMake(0, 0, 320,300);
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
}


-(void)fillView:(UIView *)thisView byObjAtIndex:(NSInteger)index {
    User_Running_History *h = [contentList objectAtIndex:index];
    
    Mission *thisMission;
    if (thisPlan.planType.integerValue == ComplexTask)
        thisMission = [thisPlan.missionList objectAtIndex:index];
    else
        thisMission = [thisPlan.missionList objectAtIndex:0];
    
    UILabel *didTimeLabel = (UILabel *)[thisView viewWithTag:101];
    didTimeLabel.text = [RORUtils transSecondToStandardFormat:h.duration.doubleValue];
    UILabel *didDistanceLabel = (UILabel *)[thisView viewWithTag:102];
    didDistanceLabel.text = [RORUtils outputDistance:h.distance.doubleValue];
    
    UILabel *sequenceLabel = (UILabel *)[thisView viewWithTag:100];
    UILabel *requireTimeLabel = (UILabel *)[thisView viewWithTag:103];
    sequenceLabel.text = [NSString stringWithFormat:@"%d", index+1];
    if (thisMission.missionDistance.doubleValue < 1){
        requireTimeLabel.text = [NSString stringWithFormat:@"计时跑：%@",[RORUtils transSecondToStandardFormat:thisMission.missionTime.doubleValue]];
    } else {
        requireTimeLabel.text = [NSString stringWithFormat:@"定距跑：%gkm",thisMission.missionDistance.doubleValue/1000];
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
    
    //    Mission *thisMission = [contentList objectAtIndex:indexPath.row];
    //    if (thisMission.missionId){
    //    }
        static NSString *CellIdentifier = @"doneCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self fillView:cell byObjAtIndex:indexPath.row];
    
    //    requireDistanceLabel.text = [RORUtils outputDistance:thisMission.missionDistance.doubleValue];
    
    return cell;
}

@end
