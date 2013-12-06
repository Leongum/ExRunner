//
//  RORSimpleTrainingViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-11-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORSimpleTrainingViewController.h"

@interface RORSimpleTrainingViewController ()

@end

@implementation RORSimpleTrainingViewController

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
    
    self.titleLabel.text = self.plan.planName;
    
    //两个按钮是否可用
    if ([self isCollectAvailable]){
        self.collectButton.enabled = YES;
        [self refreshCollectButton:self.collectButton];
        [self.collectButton addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        self.collectButton.enabled = NO;
        [self refreshCollectButton:self.collectButton];
    }
    if (self.planNext)
        self.operateButton.enabled = NO;
    else {
        self.operateButton.enabled = YES;
        [self.operateButton addTarget:self action:@selector(operateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    //label内容
    self.totalTimesLabel.text = [NSString stringWithFormat:@"总次数：%d", self.plan.totalMissions.integerValue];
    self.planIdLabel.text = [NSString stringWithFormat:@"训练编号：%@",self.plan.planId];
    self.cycleTimeLabel.text = [NSString stringWithFormat:@"频率：%d天/次", self.plan.duration.intValue];
    self.descriptionLabel.text = self.plan.planDescription;
    Mission *mission = [self.plan.missionList objectAtIndex:0];
    if (mission.missionDistance!=nil && mission.missionDistance.doubleValue>0) {
        self.trainingContentLabel.text = [NSString stringWithFormat:@"定距跑：%@", [RORUtils outputDistance:mission.missionDistance.doubleValue]];
    } else {
        self.trainingContentLabel.text = [NSString stringWithFormat:@"计时跑：%@",[RORUtils transSecondToStandardFormat:mission.missionTime.doubleValue]];
    }
    self.speedLabel.text = [NSString stringWithFormat:@"配速：%@ ~ %@",
                            [RORUserUtils formatedSpeed:mission.suggestionMaxSpeed.doubleValue], [RORUserUtils formatedSpeed:mission.suggestionMinSpeed.doubleValue]
];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
