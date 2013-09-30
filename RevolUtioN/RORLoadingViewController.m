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
    self.backButton.alpha = 0;
    
    [RORUtils setFontFamily:CHN_PRINT_FONT forView:self.view andSubViews:YES];
    [RORUtils setFontFamily:ENG_GAME_FONT forView:self.loadingLabel andSubViews:NO];
    
//    [self startIndicator:self];
    [RORNetWorkUtils initCheckNetWork];
    NSLog(@"%hhd",[RORNetWorkUtils getIsConnetioned]);

	// Do any additional setup after loading the view.
    //sync version
    Version_Control *version = [RORSystemService syncVersion:@"ios"];
    if(version != nil){
        NSString *missionLastUpdateTime = [RORUserUtils getLastUpdateTime:@"MissionUpdateTime"];
        NSString *messageLastUpdateTime = [RORUserUtils getLastUpdateTime:@"SystemMessageUpdateTime"];
        NSTimeInterval messageScape = [version.messageLastUpdateTime timeIntervalSinceDate:[RORUtils getDateFromString:messageLastUpdateTime]];
        NSTimeInterval missionScape = [version.missionLastUpdateTime timeIntervalSinceDate:[RORUtils getDateFromString:missionLastUpdateTime]];
        if(messageScape > 0){
            //sync message
            [RORSystemService syncSystemMessage];
        }
        if(missionScape > 0)
        {
            //sync missions
            [RORMissionServices syncMissions];
        }
    }
    //sync user
    NSNumber *userId = [RORUserUtils getUserId];
    if([userId intValue] > 0){
        //sync runningHistory
        [RORRunHistoryServices syncRunningHistories];
        [RORRunHistoryServices uploadRunningHistories];
        //sync userInfo.
        [RORUserServices syncUserInfoById:userId];
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
//    [self performSegueWithIdentifier:@"loadingfinished" sender:self];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    UINavigationController *navigationController =  [storyboard instantiateViewControllerWithIdentifier:@"RORNavigationController"];
    
//    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];
    sleep(3);
    
    [self presentViewController:navigationController animated:NO completion:NULL];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
