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
        self.collectButton.enabled = 1;
        [self.collectButton addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
        self.collectButton.enabled = 0;
    
    if (planNext)
        self.operateButton.enabled = 0;
    else {
        self.operateButton.enabled = 1;
        [self.operateButton addTarget:self action:@selector(operateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    //label内容
    self.totalTimesLabel.text = [NSString stringWithFormat:@"总次数：%d", self.plan.totalMissions.integerValue];
    self.cycleTimeLabel.text = [NSString stringWithFormat:@"频率：%d天/次", self.plan.cycleTime.intValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
