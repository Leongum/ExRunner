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
    [super fillContent];
    if (bestRecord.missionGrade.integerValue!=GRADE_F){
        titleLabel.text = @"本次训练完成！";
    } else {
        titleLabel.text = @"完成度不够，下次加油";
    }
    Plan_Next_mission *planNext = [RORPlanService fetchUserRunningPlanHistory];
    if (planNext){
        awardTitleLabel.text = [NSString stringWithFormat:@"下次训练请在%d天内完成",planNext.nextMission.cycleTime.integerValue];
        extraAwardLabel.text = @"";
    } else {
        extraAwardLabel.text = @"快去专项竞速试试效果吧";
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
