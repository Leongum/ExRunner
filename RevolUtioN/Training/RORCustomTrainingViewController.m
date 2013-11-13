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
    [self.frameView upfloat:1 rate:1.1f delegate:self];
    
    UIView *newView = (currentView == simpleView?advView:simpleView);
    
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.frameView cache:YES];

    [currentView removeFromSuperview];
    [self.frameView addSubview:newView];
    
    [UIView commitAnimations];

    currentView = newView;
}

@end
