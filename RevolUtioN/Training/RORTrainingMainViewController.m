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
    [self initLayout];
}

-(void)initLayout{
    planNext = [RORPlanService fetchUserRunningPlanHistory];
    
    if (planNext){
        self.currentPlanView.alpha = 1;
        
        self.bookletButton.frame = bookletButtonFrame;
        self.TraineeButton.frame = traineeButtonFrame;
        
        Plan *thisPlan = planNext.planInfo;
        contentList = thisPlan.missionList;
        historyList = planNext.history.runHistoryList;
        
        self.TrainingNameLabel.text = thisPlan.planName;
        self.process.text = [NSString stringWithFormat:@"%d/%d", planNext.nextMission.sequence.integerValue-1, thisPlan.totalMissions.integerValue];
    } else {
        self.currentPlanView.alpha = 0;
        
        self.bookletButton.frame = self.currentPlanView.frame;
        self.TraineeButton.frame = CGRectMake(self.currentPlanView.frame.origin.x, self.TraineeButton.frame.origin.y, self.currentPlanView.frame.size.width, self.TraineeButton.frame.size.height);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        leftDays.text = [NSString stringWithFormat:@"%.0f", [planNext.endTime timeIntervalSinceNow]/3600/24];
    } else {
        static NSString *CellIdentifier = @"todoCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    UILabel *sequenceLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *requireTimeLabel = (UILabel *)[cell viewWithTag:103];
    UILabel *requireDistanceLabel = (UILabel *)[cell viewWithTag:104];
    
    Mission *thisMission = [contentList objectAtIndex:indexPath.row];
    
    sequenceLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    requireTimeLabel.text = [RORUtils transSecondToStandardFormat:thisMission.missionTime.doubleValue];
    requireDistanceLabel.text = [RORUtils outputDistance:thisMission.missionDistance.doubleValue];

    return cell;
}

- (IBAction)cancelCurrentTraining:(id)sender {
}
@end
