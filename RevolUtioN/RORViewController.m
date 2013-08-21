//
//  RORViewController.m
//  RevolUtioN
//
//  Created by Bjorn on 13-8-20.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#define BACKBUTTON_FRAME CGRectMake(10, 10, 44, 44)

@interface RORViewController ()

@end

@implementation RORViewController
@synthesize backButton;

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
    [self addBackButton];
}

-(void)addBackButton{
    backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = BACKBUTTON_FRAME;
    UIImage *image = [UIImage imageNamed:@"back_bg.png"];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
