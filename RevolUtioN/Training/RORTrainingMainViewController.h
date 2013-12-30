//
//  RORTrainingMainViewController.h
//  Cyberace
//
//  Created by Bjorn on 13-11-4.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORTrainingViewController.h"
#import "RORTrainingHistoryShareView.h"

@interface RORTrainingMainViewController : RORTrainingViewController{
    CGRect bookletButtonFrame;
    CGRect traineeButtonFrame;
    NSArray *contentList;
    Plan_Next_mission *planNext;
    NSArray *historyList;
    
    NSIndexPath *todoCellIndex;
    NSNumber *fixonUserId;
    
    BOOL didInitTraineeButton;
}
@property (strong, nonatomic) Plan_Run_History *fixonPlanRunHistory;

@property (strong, nonatomic) IBOutlet UIView *currentPlanView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *bookletButton;
@property (strong, nonatomic) IBOutlet UIButton *TraineeButton;

@property (strong, nonatomic) IBOutlet UILabel *TrainingNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *process;
@property (strong, nonatomic) IBOutlet UILabel *trainingIdLabel;
@property (strong, nonatomic) IBOutlet UIImageView *trainingMainBg;

@property (strong, nonatomic) IBOutlet UIButton *giveUpButton;
@property (strong, nonatomic) IBOutlet UIImageView *bgImage;

@end
