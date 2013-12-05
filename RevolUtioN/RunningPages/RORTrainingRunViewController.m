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
    
    if (thisMission.missionDistance.integerValue>0){
        self.titleLabel.text = [NSString stringWithFormat:@"定距跑：%gkm", thisMission.missionDistance.doubleValue/1000];
        trainingType = TrainingContentTypeDistance;
    } else {
        self.titleLabel.text = [NSString stringWithFormat:@"计时跑：%@", [RORUtils transSecondToStandardFormat:thisMission.missionTime.doubleValue]];
        trainingType = TrainingContentTypeDuration;
    }
    finishSound = [[RORPlaySound alloc]initForPlayingSoundEffectWith:@"running_end1.mp3"];
    last10Min = [[RORPlaySound alloc]initForPlayingSoundEffectWith:@"last_kilo.mp3"];
    
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
    runHistory.grade = [self calculateTrainingGrade];
    if (runHistory.grade.integerValue!= GRADE_F){
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
    if (reqDuration>0 && duration > reqDuration*0.8){
        return [NSNumber numberWithInt:GRADE_S];
    }
    if (reqDistance>0 && distance > reqDistance*0.8){
        return [NSNumber numberWithInt:GRADE_S];
    }
    
    return [NSNumber numberWithInt:GRADE_F];
}

-(void)timerSecondDot{
    [super timerSecondDot];
    if (trainingType == TrainingContentTypeDistance){
        double mDistance = thisMission.missionDistance.doubleValue;
        double leftDistance = mDistance-distance;

        if (leftDistance < 1000 && !lastKiloPlayed){
            lastKiloPlayed = YES;
            [lastKilo play];
        }
        if (leftDistance < 100 && !lastHundredPlayed){
            lastHundredPlayed = YES;
            [lastHundred play];
        }

        self.distanceLabel.text = [RORUtils outputDistance:distance];
        self.speedLabel.text = [RORUserUtils formatedSpeed:currentSpeed*3.6];
        
        if (leftDistance<=0 && !finished){
            [finishSound play];
            finished = YES;
        }
    } else {
        double mDuration = thisMission.missionTime.doubleValue;
        double leftDuration = mDuration-duration;
        
        if (leftDuration < 600 && !last10MinPlayed){
            last10MinPlayed = YES;
            [last10Min play];
        }
        if (leftDuration<=0 && !finished){
            [finishSound play];
            finished = YES;
        }
    }
}
@end
