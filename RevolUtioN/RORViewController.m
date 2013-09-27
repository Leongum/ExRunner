//
//  RORViewController.m
//  RevolUtioN
//
//  Created by Bjorn on 13-8-20.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "FTAnimation.h"

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
    [self.view setAutoresizesSubviews:YES];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addBackButton];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)addBackButton{
    backButton = [[RORNormalButton alloc]initWithFrame:BACKBUTTON_FRAME_TOP ];//[RORNormalButton buttonWithType:UIButtonTypeRoundedRect];
//    [backButton initButtonInteraction];
    backButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    //CGRect rx = [ UIScreen mainScreen ].applicationFrame;
//    backButton.frame = BACKBUTTON_FRAME_TOP;
//    if (rx.size.height == 460){
//        backButton.frame = BACKBUTTON_FRAME_NORMAL;
//    } else {
//        backButton.frame = BACKBUTTON_FRAME_RETINA;
//    }
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

-(void)sendNotification:(NSString *)message{
    if (notificationView == nil){
        notificationView = [[RORNotificationView alloc]init];
        [self.view addSubview:notificationView];
    }
    [notificationView popNotification:self Message:message];
}

-(void)sendAlart:(NSString *)message{
    if (notificationView == nil){
        notificationView = [[RORNotificationView alloc]init];
        [self.view addSubview:notificationView];
    }
    [notificationView popNotification:self Message:message andType:RORNOTIFICATION_TYPE_IMPORTANT];
}

@end
