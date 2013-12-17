//
//  RORCustomTrainingViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-11-8.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORCustomTrainingViewController.h"
#import "FTAnimation.h"

@interface RORCustomTrainingViewController ()

@end

@implementation RORCustomTrainingViewController

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
    
    [self loadViewControllers];
}

-(void)loadViewControllers{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TrainingStoryboard" bundle:[NSBundle mainBundle]];
    advViewController =  [storyboard instantiateViewControllerWithIdentifier:@"creatAdvTrainingController"];
    simpleViewController =  [storyboard instantiateViewControllerWithIdentifier:@"creatSimpleTrainingController"];
    
    CGRect frame = self.frameView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    advViewController.view.frame = frame;
    simpleViewController.view.frame = frame;
    
    [self addChildViewController:simpleViewController];
    [self.frameView addSubview:simpleViewController.view];
    [simpleViewController didMoveToParentViewController:self];
    [self addChildViewController:advViewController];
    [advViewController didMoveToParentViewController:self];
    advView = advViewController.view;
    simpleView = simpleViewController.view;
    
    currentView = simpleView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)switchTrainingType:(id)sender {
    UIView *newView;
    
    if (currentView == simpleView){
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"creatTrainingSwitchButton1_bg.png"] forState:UIControlStateNormal];
        newView = advView;
    } else {
        [self.switchButton setBackgroundImage:[UIImage imageNamed:@"creatTrainingSwitchButton_bg.png"] forState:UIControlStateNormal];
        newView = simpleView;
    }
    
//    [self.frameView upfloat:1 rate:1.1f delegate:self];
    
//    [UIView beginAnimations:@"animation" context:nil];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.frameView cache:YES];

//    currentView.alpha = 0;
//    [self.frameView fold:0.3 delegate:self startSelector:nil stopSelector:@selector(expandView:)];
    [self.frameView expand:0.6 delegate:self];
//    [self.frameView slideInFrom:kFTAnimationTop duration:0.5 delegate:self];
    [currentView removeFromSuperview];
    [self.frameView addSubview:newView];
    
    
//    [UIView commitAnimations];

    currentView = newView;
}

-(IBAction)expandView:(id)sender{
    currentView.alpha = 1;
}

- (IBAction)submitAction:(id)sender {
    if ([RORUserUtils getUserId].integerValue>0){
        Plan *newPlan;
        if (currentView == simpleView){
            newPlan = [simpleViewController createNewSimplePlan];
        }
        else if (currentView == advView){
            newPlan = [advViewController createNewAdvancedPlan];
            NSLog(@"new created plan:======\n%@", newPlan);
        }
        
        if (!newPlan)
            return;
        
        newPlan = [RORPlanService createSelfPlan:newPlan];
        NSLog(@"after syncronized new created plan:======\n%@", newPlan);
        if (newPlan){
            [self sendSuccess:@"创建成功！\n已添加至[我的收藏]"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else
        [self sendAlart:@"请先登录"];
}

@end
