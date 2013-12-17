//
//  RORTrainingRunViewController.h
//  Cyberace
//
//  Created by Bjorn on 13-11-23.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORRunningViewController.h"
#import "RORPlanService.h"

@interface RORTrainingRunViewController : RORRunningViewController{
    NSTimer *pauseLimitedTimer;
    int pauseTimerCount;
    Plan_Run_History *planRunningHistory;
    Plan_Next_mission *planNext;
    RORPlaySound *finishSound;
    
    int trainingType;
    BOOL finished;
}

@property (strong, nonatomic)     Mission *thisMission;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *suggestedSpeed;

@end
