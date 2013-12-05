//
//  RORTrainingDetailViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-11-20.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORTrainingDetailViewController.h"
#import "RORTrainingMainViewController.h"

@interface RORTrainingDetailViewController ()

@end

@implementation RORTrainingDetailViewController
@synthesize plan;
@synthesize delegate;

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

-(IBAction)collectAction:(id)sender{
    [RORPlanService collectPlan:plan];
}

-(BOOL)isCollectAvailable{
    NSArray *collectList = [RORPlanService fetchPlanCollect:[RORUserUtils getUserId]];
    for (Plan *itPlan in collectList)
        if (itPlan.planId.integerValue == plan.planId.integerValue)
            return NO;
    
    return YES;
}

-(IBAction)operateAction:(id)sender{
    
    [RORPlanService startNewPlan:plan.planId];
    
    UIViewController *viewController = delegate;
    
    while (![viewController isKindOfClass:[RORTrainingMainViewController class]]) {
        viewController = (UIViewController *)[viewController valueForKey:@"delegate"];
    }
    
    [self.navigationController popToViewController:viewController animated:YES];
}
@end
