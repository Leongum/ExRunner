//
//  RORCreatSimpleTrainingViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-11-8.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORCreatSimpleTrainingViewController.h"

@interface RORCreatSimpleTrainingViewController ()

@end

@implementation RORCreatSimpleTrainingViewController

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
    self.backButton.alpha = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
