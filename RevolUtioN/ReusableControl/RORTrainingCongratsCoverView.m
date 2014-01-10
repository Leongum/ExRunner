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
    self = [super initWithFrame:frame andLevel:record];
    if (self) {
        bestRecord = record;
        [self fillContent];
    }
    return self;
}

-(void)fillContent{
    [super fillContent];
    titleLabel.text = @"这次训练你得了";
    Plan_Next_mission *planNext = [RORPlanService fetchUserRunningPlanHistory];
    if (planNext){
        if (bestRecord.missionGrade.integerValue!=GRADE_F){
            awardTitleLabel.text = [NSString stringWithFormat:@"干得漂亮！下次训练请在%d天内完成",planNext.nextMission.cycleTime.integerValue];
        } else {
            awardTitleLabel.text = @"完成度不够，下次加油";
        }
        if (bestRecord.avgSpeed.doubleValue>7)
            extraAwardLabel.text = @"建议至少休息一天";
        else
            extraAwardLabel.text = @"";
    } else {
        extraAwardLabel.text = @"快去“比赛”试试效果吧";
        awardTitleLabel.text = @"训练已全部完成";
    }
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
