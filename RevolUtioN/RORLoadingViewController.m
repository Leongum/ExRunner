//
//  RORLoadingViewController.m
//  RevolUtioN
//
//  Created by leon on 13-8-6.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORLoadingViewController.h"
#import "RORMissionServices.h"
#import "RORUserServices.h"
#import "RORRunHistoryServices.h"
#import "RORSystemService.h"
#import "RORNetWorkUtils.h"

@interface RORLoadingViewController ()

@end

@implementation RORLoadingViewController

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
    [RORNetWorkUtils initCheckNetWork];
	// Do any additional setup after loading the view.
    //sync version
    [RORSystemService syncVersion:@"ios"];
    //sync user
    NSNumber *userId = [RORUserUtils getUserId];
    if([userId intValue] > 0){
        //sync runningHistory
        [RORRunHistoryServices syncRunningHistories];
        [RORRunHistoryServices uploadRunningHistories];
        //sync userInfo.
        [RORUserServices syncUserInfoById:userId];
    }
    //sync missions
    [RORMissionServices syncMissions];
    
}

-(void)viewDidAppear:(BOOL)animated{
//    [self performSegueWithIdentifier:@"loadingfinished" sender:self];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    UINavigationController *navigationController =  [storyboard instantiateViewControllerWithIdentifier:@"RORNavigationController"];
    sleep(1);
    [self presentViewController:navigationController animated:NO completion:NULL];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
