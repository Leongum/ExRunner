//
//  RORTrainingCongratsCoverView.m
//  Cyberace
//
//  Created by Bjorn on 13-11-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORTrainingCongratsCoverView.h"
#import "RORPlanService.h"

@implementation RORTrainingCongratsCoverView
@synthesize bestRecord;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andLevel:(User_Running_History*)record
{
    self = [super initWithFrame:frame];
    if (self) {
        bestRecord = record;
        [self fillContent];
    }
    return self;
}

-(void)fillContent{
    if (bestRecord.missionGrade.integerValue>=60){
        titleLabel.text = @"训练完成！";
    } else {
        
    }
    
    Plan_Next_mission *planNext = [RORPlanService fetchUserRunningPlanHistory];
    levelLabel = [[UILabel alloc]initWithFrame:self.frame];
    levelLabel.backgroundColor = [UIColor clearColor];
    levelLabel.font = [UIFont fontWithName:ENG_GAME_FONT size:20];
    levelLabel.textColor = [UIColor yellowColor];
    levelLabel.textAlignment = NSTextAlignmentCenter;
    levelLabel.text = [NSString stringWithFormat:@"下次训练需要在%d天内完成",planNext.nextMission.cycleTime.intValue];
    levelLabel.alpha = 0;
    [self addSubview:levelLabel];
    
    extraAwardLabel.text = [NSString stringWithFormat:@"exp: %d   gold: %d", bestRecord.experience.integerValue, bestRecord.scores.integerValue];
    
    [self addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
