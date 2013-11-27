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
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(pauseTimerDot) userInfo:nil repeats:YES];
    repeatingTimer = timer;
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
    runHistory.grade = [self calculateTrainingScore];
}

//计算单次训练完成的分数，百分制，以判定本次训练是否完成
-(NSNumber *)calculateTrainingScore{
    return [NSNumber numberWithInt:60];
}
@end
