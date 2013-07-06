//
//  RORHistoryDetailViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORHistoryDetailViewController.h"
#import "RORPublicMethods.h"
#import "RORRunningViewController.h"
#import "RORDBCommon.h"

@interface RORHistoryDetailViewController ()

@end

@implementation RORHistoryDetailViewController
@synthesize distanceLabel, speedLabel, durationLabel, energyLabel, weatherLabel, scoreLabel, experienceLabel, bonusLabel;
@synthesize record;
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
    
    distanceLabel.text = [NSString stringWithFormat:@"%.2f", [record.distance floatValue]];
    speedLabel.text = [NSString stringWithFormat:@"%.1f", [record.avgSpeed floatValue]];
    durationLabel.text = [RORPublicMethods transSecondToStandardFormat:[record.duration integerValue]];
    energyLabel.text = [NSString stringWithFormat:@"%d", [record.spendCarlorie integerValue]];
    scoreLabel.text = [NSString stringWithFormat:@"%d", [record.scores integerValue]];
    experienceLabel.text = [NSString stringWithFormat:@"%d" ,[record.experience integerValue]];
//    [self.navigationItem.backBarButtonItem setAction:@selector(backToMain:)];
//    [delegate viewDidLoad];
}

//-(void)backToMain:(id)sender {
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDistanceLabel:nil];
    [self setSpeedLabel:nil];
    [self setDurationLabel:nil];
    [self setEnergyLabel:nil];
    [self setWeatherLabel:nil];
    [self setScoreLabel:nil];
    [self setExperienceLabel:nil];
    [self setBonusLabel:nil];
    [self setBackButtonItem:nil];
    [self setRecord:nil];
    [self setDelegate:nil];
    [self setBackButtonItem:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setRoutePoints:)]){
        [destination setValue:[RORDBCommon getRoutePointsFromString:record.missionRoute] forKey:@"routePoints"];
    }
}

- (IBAction)backAction:(id)sender {
    if ([delegate isKindOfClass:[RORRunningViewController class]])
        [self.navigationController popToRootViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:YES];
}
@end
