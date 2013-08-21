//
//  RORHistoryDetailViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORHistoryDetailViewController.h"
#import "RORRunningViewController.h"
#import "RORDBCommon.h"
#import "RORUtils.h"
#import "RORShareService.h"

@interface RORHistoryDetailViewController ()

@end

@implementation RORHistoryDetailViewController
@synthesize distanceLabel, speedLabel, durationLabel, energyLabel, weatherLabel, scoreLabel, experienceLabel, bonusLabel;
@synthesize record;
@synthesize coverView;
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
    durationLabel.text = [RORUtils transSecondToStandardFormat:[record.duration integerValue]];
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
    [self setCoverView:nil];
    [super viewDidUnload];
}

- (UIImage *) captureScreen {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect contentRectToCrop = CGRectMake(0, 70, image.size.width, image.size.height - 70);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], contentRectToCrop);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    return croppedImage;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setRoutePoints:)]){
        [destination setValue:[RORDBCommon getRoutePointsFromString:record.missionRoute] forKey:@"routePoints"];
    }
    if ([destination respondsToSelector:@selector(setShareImage:)]){
        [destination setValue:[self captureScreen] forKey:@"shareImage"];
    }
}

- (IBAction)backAction:(id)sender {
    if ([delegate isKindOfClass:[RORRunningViewController class]])
        [self.navigationController popToRootViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareAction:(id)sender {
    [Animations fadeIn:coverView andAnimationDuration:0.3 toAlpha:1 andWait:NO];
    [Animations fadeOut:self.backButton andAnimationDuration:0.3 fromAlpha:1 andWait:YES];
}

- (IBAction)hideCover:(id)sender {
    [Animations fadeOut:coverView andAnimationDuration:0.3 fromAlpha:1 andWait:NO];
    [Animations fadeIn:self.backButton andAnimationDuration:0.3 toAlpha:1 andWait:YES];
}

@end
