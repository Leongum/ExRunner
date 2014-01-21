//
//  RORTrainingRunViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-11-23.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORTrainingRunViewController.h"

@interface RORTrainingRunViewController ()

@end

@implementation RORTrainingRunViewController
@synthesize thisMission;

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
    planNext = [RORPlanService fetchUserRunningPlanHistory];
    
    trainingType = [RORPlanService getTrainingTypeFromMission:thisMission];
    self.titleLabel.text = [RORPlanService getStringByTrainingType:thisMission];
    
    self.suggestedSpeed.text = [NSString stringWithFormat:@"配速：%@ ~ %@", [RORUserUtils formatedSpeed:thisMission.suggestionMaxSpeed.doubleValue], [RORUserUtils formatedSpeed:thisMission.suggestionMinSpeed.doubleValue]];
    allInOneSound = [[RORMultiPlaySound alloc] init];
    totalKM = 0;
    finished = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)performSegue{
    [self performSegueWithIdentifier:@"TrainingRunResultSeague" sender:self];
}

- (IBAction)startButtonAction:(id)sender {
    [super startButtonAction:sender];
    if (!isStarted){
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(pauseTimerDot) userInfo:nil repeats:YES];
        pauseLimitedTimer = timer;
    } else {
        [pauseLimitedTimer invalidate];
        pauseLimitedTimer = nil;
    }
}

-(void)pauseTimerDot{
    pauseTimerCount++;
    if (pauseTimerCount>3600*3){
        [self btnSaveRun:self];
    }
}

-(void)creatRunningHistory{
    [super creatRunningHistory];
    planRunningHistory = [Plan_Run_History intiUnassociateEntity];
    runHistory.missionTypeId = thisMission.missionTypeId;
    runHistory.missionGrade = [self calculateTrainingGrade];
    if (runHistory.missionGrade.integerValue!= GRADE_F && runHistory.valid.integerValue>0){
        [RORPlanService gotoNextMission:planNext.planRunUuid];
    }
    
    runHistory.planRunUuid = planNext.planRunUuid;
    NSLog(@"%@", runHistory.planRunUuid);
    int seq = planNext.planInfo.totalMissions.integerValue - planNext.history.remainingMissions.integerValue;
    runHistory.sequence = [NSNumber numberWithInt:seq];
}

//计算单次训练完成的分数，百分制，以判定本次训练是否完成
-(NSNumber *)calculateTrainingGrade{
    double reqDuration = planNext.nextMission.missionTime.doubleValue;
    double reqDistance = planNext.nextMission.missionDistance.doubleValue;
    double score;
    if (reqDistance>0){
        score = 200*distance/reqDistance-100;
    } else {
        score = 200*duration/reqDuration-100;
    }
    
    if (score<60)
        return [NSNumber numberWithInt:GRADE_F];
    if (score<65)
        return [NSNumber numberWithInt:GRADE_E];
    if (score<70)
        return [NSNumber numberWithInt:GRADE_D];
    if (score<75)
        return [NSNumber numberWithInt:GRADE_C];
    if (score<90)
        return [NSNumber numberWithInt:GRADE_B];
    if (score<100)
        return [NSNumber numberWithInt:GRADE_A];
    
    return [NSNumber numberWithInt:GRADE_S];
}

-(void)timerSecondDot{
    [super timerSecondDot];
    if(totalKM < avgSpeedPerKMList.count){
        double maxSpeed = thisMission.suggestionMaxSpeed.doubleValue;
        double minSpeed = thisMission.suggestionMinSpeed.doubleValue;
        double lastKMSpeed = ((NSNumber*)[avgSpeedPerKMList objectAtIndex:(avgSpeedPerKMList.count -1)]).doubleValue;
        lastKMSpeed = 3600/lastKMSpeed;
        [allInOneSound addFileNametoQueue:@"kilo_tip.mp3"];
        if(maxSpeed< lastKMSpeed){
            [allInOneSound addFileNametoQueue:@"run_slower.mp3"];
        }else if(minSpeed >lastKMSpeed){
            [allInOneSound addFileNametoQueue:@"run_faster.mp3"];
        }
        else{
            [allInOneSound addFileNametoQueue:@"run_at_speed.mp3"];
        }
        totalKM++;
    }
    if (trainingType == TrainingContentTypeDistance){
        double mDistance = thisMission.missionDistance.doubleValue;
        double leftDistance = mDistance-distance;

        if (leftDistance < 1000 && !lastKiloPlayed){
            lastKiloPlayed = YES;
            [allInOneSound addFileNametoQueue:@"last_kilo.mp3"];
        }

        self.distanceLabel.text = [RORUtils outputDistance:distance];
        self.speedLabel.text = [RORUserUtils formatedSpeed:currentSpeed*3.6];
        
        if (leftDistance<=0 && !finished){
            [allInOneSound addFileNametoQueue:@"running_end1.mp3"];
            finished = YES;
        }
    } else {
        double mDuration = thisMission.missionTime.doubleValue;
        double leftDuration = mDuration-duration;
        
        if (leftDuration < 300 && !last5MinPlayed){
            last5MinPlayed = YES;
            [allInOneSound addFileNametoQueue:@"last_5_min.mp3"];
        }
        if (leftDuration<=0 && !finished){
            [allInOneSound addFileNametoQueue:@"running_end1.mp3"];
            finished = YES;
        }
    }
    [allInOneSound play];
}
@end
