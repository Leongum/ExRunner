//
//  RORStatisticsViewController.m
//  RevolUtioN
//
//  Created by Bjorn on 13-8-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORStatisticsViewController.h"
#import "RORHistoryPageViewController.h"

@interface RORStatisticsViewController ()

@end

@implementation RORStatisticsViewController
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
    [RORUtils setFontFamily:CHN_PRINT_FONT forView:self.view andSubViews:YES];
    
    [self.totalDistanceLabel setFont:[UIFont fontWithName:ENG_WRITTEN_FONT size:28]];
    [self.totalSpeedLabel setFont:[UIFont fontWithName:ENG_WRITTEN_FONT size:28]];
    [self.totalCalorieLabel setFont:[UIFont fontWithName:ENG_WRITTEN_FONT size:28]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initTableData];
}

-(void)initTableData{
    totalCalorie = 0;
    totalDistance = 0;  
    avgSpeed = 0;
    
    NSMutableArray *filter = ((RORHistoryPageViewController*)[self parentViewController]).filter;
    
    NSArray *fetchObject = [RORRunHistoryServices fetchRunHistory];

    for (User_Running_History *historyObj in fetchObject) {
        NSNumber *missionType = (NSNumber *)[historyObj valueForKey:@"missionTypeId"];
        
        if (![filter containsObject:missionType]) {
            continue;
        }
        totalDistance += historyObj.distance.doubleValue;
        totalCalorie += historyObj.spendCarlorie.doubleValue;
        avgSpeed += historyObj.avgSpeed.doubleValue;
    }
    avgSpeed/=fetchObject.count;
    if (fetchObject.count>0){
        [self showContents];
        self.totalDistanceLabel.text = [RORUtils outputDistance:totalDistance];
        self.totalSpeedLabel.text = [RORUserUtils formatedSpeed:avgSpeed];
        self.totalCalorieLabel.text = [NSString stringWithFormat:@"%.2f kca", totalCalorie];
    } else {
        [self hideContents];
        self.totalSpeedLabel.text = NO_HISTORY;
        
    }
}

-(void)showContents{
    for (int i=1; i<7; i++){
        UIView *view = [self.containerView viewWithTag:i];
        view.alpha = 1;
    }
    self.totalDistanceLabel.alpha =1;
    self.totalCalorieLabel.alpha = 1;
    [RORUtils setFontFamily:ENG_WRITTEN_FONT forView:self.totalSpeedLabel andSubViews:NO];
}

-(void)hideContents{
    for (int i=1; i<7; i++){
        UIView *view = [self.containerView viewWithTag:i];
        view.alpha = 0;
    }
    self.totalDistanceLabel.alpha =0;
    self.totalCalorieLabel.alpha = 0;
    [RORUtils setFontFamily:CHN_PRINT_FONT forView:self.totalSpeedLabel andSubViews:NO];
}

- (void)viewDidUnload {
    [self setTotalDistanceLabel:nil];
    [self setTotalSpeedLabel:nil];
    [self setTotalCalorieLabel:nil];
    [self setContainerView:nil];
    [super viewDidUnload];
}
@end
