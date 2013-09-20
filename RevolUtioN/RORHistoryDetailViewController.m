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

@implementation RORHistoryDetailViewController{

    UIImage *img;
}

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
    NSLog(@"%@", record);
    distanceLabel.text = [RORUtils outputDistance:record.distance.doubleValue];
    NSLog(@"%f", record.avgSpeed.doubleValue/3.6);
    speedLabel.text = [RORUserUtils formatedSpeed:record.avgSpeed.doubleValue/3.6];
    durationLabel.text = [RORUtils transSecondToStandardFormat:record.duration.integerValue];
    energyLabel.text = [NSString stringWithFormat:@"%.1f kca", record.spendCarlorie.doubleValue];
    
    scoreLabel.text = [NSString stringWithFormat:@"%@", record.grade];
    bonusLabel.text = [NSString stringWithFormat:@"%@", record.scores];
    experienceLabel.text = [NSString stringWithFormat:@"%@" , record.experience];
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
    CGImageRelease(imageRef);
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
        [destination setValue:img forKey:@"shareImage"];
    }
}

- (IBAction)backAction:(id)sender {
    if ([delegate isKindOfClass:[RORRunningViewController class]]){
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareToWeixin:(id)sender {
    [self hideCover:self];
    
    //发送内容给微信
    id<ISSContent> content = [ShareSDK content:nil
                                defaultContent:nil
                                         image:[ShareSDK jpegImageWithImage:img quality:1]
                                         title:nil
                                           url:nil
                                   description:nil
                                     mediaType:SSPublishContentMediaTypeImage];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    
    [ShareSDK shareContent:content
                      type:ShareTypeWeixiTimeline
               authOptions:authOptions
             statusBarTips:YES
                    result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(@"success");
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            if ([error errorCode] == -22003)
                            {
                                [self sendNotification:[error errorDescription]];
                            }
                        }
                    }];

}

- (IBAction)shareAction:(id)sender {
    img = [self captureScreen];
    [Animations fadeIn:coverView andAnimationDuration:0.3 toAlpha:1 andWait:NO];
    [Animations fadeOut:self.backButton andAnimationDuration:0.3 fromAlpha:1 andWait:NO];
}

- (IBAction)hideCover:(id)sender {
    [Animations fadeOut:coverView andAnimationDuration:0.3 fromAlpha:1 andWait:NO];
    [Animations fadeIn:self.backButton andAnimationDuration:0.3 toAlpha:1 andWait:NO];
}

@end
