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
    [RORUtils setFontFamily:@"FZKaTong-M19S" forView:self.view andSubViews:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
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
    
    self.totalDistanceLabel = [NSString stringWithFormat:@"%.2f", totalDistance];
    self.totalSpeedLabel = [NSString stringWithFormat:@"%.2f", avgSpeed];
    self.totalCalorieLabel = [NSString stringWithFormat:@"%.2f", totalCalorie];
}

- (void)viewDidUnload {
    [self setTotalDistanceLabel:nil];
    [self setTotalSpeedLabel:nil];
    [self setTotalCalorieLabel:nil];
    [super viewDidUnload];
}
@end
