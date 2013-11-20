//
//  RORTrainingDetailViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-11-20.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORTrainingDetailViewController.h"

@interface RORTrainingDetailViewController ()

@end

@implementation RORTrainingDetailViewController
@synthesize plan;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)collectAction:(id)sender{
    Plan_Collect *planCollect = [Plan_Collect initUnassociateEntity];
    planCollect.planId = plan.planId;
    planCollect.userId = [RORUserUtils getUserId];
    planCollect.collectStatus = PLAN_COLLECT_STATUS_COLLECTED;
    
    [RORPlanService updatePlanCollect:planCollect];
}

-(IBAction)operateAction:(id)sender{
    
}
@end
