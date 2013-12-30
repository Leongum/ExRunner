//
//  RORCustomTrainingViewController.h
//  Cyberace
//
//  Created by Bjorn on 13-11-8.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "RORCreatAdvTrainingViewController.h"
#import "RORCreatSimpleTrainingViewController.h"

@interface RORCustomTrainingViewController : RORViewController{
    RORCreatAdvTrainingViewController *advViewController;
    RORCreatSimpleTrainingViewController *simpleViewController;
    UIView *advView;
    UIView *simpleView;
    UIView *currentView;
}

@property (strong, nonatomic) IBOutlet UIView *frameView;
@property (strong, nonatomic) IBOutlet UIButton *switchButton;
@property (strong, nonatomic) IBOutlet UIImageView *coverView;

-(IBAction)showCoverView:(id)sender;
-(IBAction)hideCoverView:(id)sender;

@end
