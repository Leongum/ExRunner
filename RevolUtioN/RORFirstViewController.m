//
//  RORFirstViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-4-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORFirstViewController.h"
#import "FTAnimation.h"

//#define CHARACTOR_FRAME_NORMAL CGRectMake(10,300,280,183)
//#define CHARACTOR_FRAME_RATINA CGRectMake(10,300,280,183)

#define WEATHER_BUTTON_INITIAL_FRAME CGRectMake(-100, 27, 100, 40)
#define LOGIN_BUTTON_INITIAL_FRAME CGRectMake(320, 14, 210, 69)

#define RUN_BUTTON_FRAME_NORMAL CGRectMake(92, 120, 136, 60)
#define RUN_BUTTON_FRAME_RATINA CGRectMake(92, 160, 136, 60)
#define CHALLENGE_BUTTON_FRAME_NORMAL CGRectMake(0, 190, 320, 94)
#define CHALLENGE_BUTTON_FRAME_RATINA CGRectMake(0, 250, 320, 94)


@interface RORFirstViewController ()

@end

@implementation RORFirstViewController
@synthesize weatherInfoButtonView;
@synthesize locationManager;

NSInteger expanded = 0;
BOOL isWeatherButtonClicked = false;
NSInteger centerLoc =-10000;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [RORUtils setFontFamily:CHN_PRINT_FONT forView:self.view andSubViews:YES];
    
    [self prepareControlsForAnimation];
    
    //初始化按钮位置
    [self initControlsLayout];
    
//    [RORUtils listFontFamilies];
}

-(void)viewWillDisappear:(BOOL)animated{
    [locationManager stopUpdatingLocation];
    [super viewWillDisappear:animated];
}

-(void)prepareControlsForAnimation{
    hasAnimated = NO;
//    self.chactorView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
//    self.chactorView.frame = CHARACTOR_FRAME_NORMAL;
    self.chactorView.alpha = 0;
    self.charactorWindView.alpha = 0;
    self.weatherInfoButtonView.frame = WEATHER_BUTTON_INITIAL_FRAME;
    self.userInfoView.frame = LOGIN_BUTTON_INITIAL_FRAME;
    
    self.runButton.alpha = 0;
    self.challenge.alpha = 0;
    self.historyButton.alpha = 0;
    self.settingButton.alpha = 0;
}

- (void)initLocationServcie{
    userLocation = nil;
    wasFound = NO;
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    // start the compass
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    userLocation = newLocation;
    wasFound = YES; 
    if (wasFound){
//        [locationManager stopUpdatingLocation];
        [self getCitynameByLocation];
    }
//    NSLog(@"Device did %f meters move.", [self.latestUserLocation getDistanceFrom:newLocation]);
//    self.latestUserLocation = [self transToRealLocation:newLocation];
    
}

- (void)initControlsLayout{
    [self.backButton setAlpha:0];
    
    CGRect rx = [ UIScreen mainScreen ].applicationFrame;
    if (rx.size.height == 460){
        self.runButton.frame = RUN_BUTTON_FRAME_NORMAL;
        self.challenge.frame = CHALLENGE_BUTTON_FRAME_NORMAL;
    } else {
        self.runButton.frame = RUN_BUTTON_FRAME_RATINA;
        self.challenge.frame = CHALLENGE_BUTTON_FRAME_RATINA;
    }
    
    
}

- (void)initPageData{
//    [self.loginButton.titleLabel setFont: [UIFont fontWithName:@"FZKaTong-M19S" size:20]];
//    [self.levelLabel setFont:[UIFont fontWithName:@"FZKaTong-M19S" size:15]];
//    [self.scoreLabel setFont:[UIFont fontWithName:@"FZKaTong-M19S" size:15]];
//    [self.usernameLabel setFont:[UIFont fontWithName:@"FZKaTong-M19S" size:20]];

    //初始化用户名
    if ([RORUserUtils getUserId].integerValue>=0){
        self.loginButton.alpha = 0;
        
        User_Base *userInfo = [RORUserServices fetchUser:[RORUserUtils getUserId]];
        self.usernameLabel.text = userInfo.nickName;
        [RORUtils setFontFamily:ENG_PRINT_FONT forView:self.usernameLabel andSubViews:NO];
        self.levelLabel.text = [NSString stringWithFormat:@"%.1f", userInfo.attributes.level.doubleValue];
        [RORUtils setFontFamily:ENG_PRINT_FONT forView:self.levelLabel andSubViews:NO];
        self.scoreLabel.text = [NSString stringWithFormat:@"%d", userInfo.attributes.scores.integerValue];
        [RORUtils setFontFamily:ENG_PRINT_FONT forView:self.scoreLabel andSubViews:NO];
    } else {
        self.loginButton.alpha = 1;
    }
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initPageData];
    if (!hasAnimated){
        hasAnimated = YES;
        [self charactorAnimation];
        [self controlsInAction];
    }
//    [Animations zoomIn:self.chactorView andAnimationDuration:2 andWait:YES];
    [self initLocationServcie];

}

- (IBAction)segueToLogin:(id)sender{
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
}

-(void)getCitynameByLocation {
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:userLocation completionHandler:^(NSArray *placemarks, NSError *error){
        CLPlacemark *placemark = (CLPlacemark *)[placemarks objectAtIndex:0];
        NSLog(@"%@, %@, %@, %@, %@, %@", placemark.country, placemark.administrativeArea, placemark.subLocality, placemark.thoroughfare, placemark.subThoroughfare, placemark.name);
        cityName = placemark.subLocality;
        NSString * provinceName = placemark.administrativeArea;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *weatherInfo = [RORThirdPartyService syncWeatherInfo:[RORUtils getCitycodeByCityname:cityName]];
            NSDictionary *pm25info =[RORThirdPartyService syncPM25Info:cityName withProvince:provinceName];
            dispatch_async(dispatch_get_main_queue(), ^{
                weatherInformation = @"";
                int temp = INT16_MAX;
                int pm25 = INT16_MAX;
                if (weatherInfo != nil){
                    temp = [[weatherInfo objectForKey:@"temp"] integerValue];
                    weatherInformation = [NSString stringWithFormat:@"%@%@  %d℃  %@%@  ", weatherInformation, cityName, temp, [weatherInfo objectForKey:@"WD"],[weatherInfo objectForKey:@"WS"]
                                          ];
                }
                if(pm25info != nil){
                    pm25 = [[pm25info objectForKey:@"pm2_5"] integerValue];
                    weatherInformation = [NSString stringWithFormat:@"%@  PM2.5:%d%@  ", weatherInformation,  pm25,[pm25info objectForKey:@"quality"]];
                }
                int index = 60;
                if(temp < 38 && pm25 < 300){
                    index = (100-pm25/3)*0.6 +(100-fabs(temp - 22)*5)*0.4;
                }
                
                weatherInformation = [NSString stringWithFormat:@"%@总:%d", weatherInformation, index];
                if (temp < 0 || temp > 38 || pm25>300 || index<50){
                    UIImage *image = [UIImage imageNamed:@"main_trafficlight_red.png"];
                    [weatherInfoButtonView setImage:image forState:UIControlStateNormal];
                }
                else if (index<75){
                    UIImage *image = [UIImage imageNamed:@"main_trafficlight_yellow.png"];
                    [weatherInfoButtonView setImage:image forState:UIControlStateNormal];
                }
                else{
                    UIImage *image = [UIImage imageNamed:@"main_trafficlight_green.png"];
                    [weatherInfoButtonView setImage:image forState:UIControlStateNormal];
                }
            });
        });
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setSelection:)]){
        [destination setValue:self.userName forKey:@"userName"];
        [destination setValue:self.userId forKey:@"userId"];
    }
    if ([destination respondsToSelector:@selector(setMissionType:)]){
        [destination setValue:[NSNumber numberWithInteger:NormalRun] forKey:@"missionType"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWeatherInfoButtonView:nil];
    [self setUserName:nil];
    [self setUserId:nil];
    
    [self setRunButton:nil];
    [self setChallenge:nil];
    [self setUsernameLabel:nil];
    [self setLevelLabel:nil];
    [self setScoreLabel:nil];
    [self setUserInfoView:nil];
    [self setLoginButton:nil];
    [self setChactorView:nil];
    [self setHistoryButton:nil];
    [self setSettingButton:nil];
    [self setCharactorWindView:nil];
    [super viewDidUnload];
}

-(void)charactorAnimation{
    [Animations zoomIn:self.chactorView andAnimationDuration:2 andWait:NO];
    self.chactorView.alpha = 1;
    [Animations moveUp:self.chactorView andAnimationDuration:1 andWait:YES andLength:20];
    [Animations fadeIn:self.charactorWindView andAnimationDuration:1 toAlpha:1 andWait:YES];
//    [Animations moveDown:self.chactorView andAnimationDuration:1 andWait:YES andLength:20];
}

-(void)controlsInAction{
//    self.weatherInfoButtonView
    
    [self.runButton fallIn:0.5 delegate:self];
    [self.challenge fallIn:0.5 delegate:self];
    self.runButton.alpha = 1;
    self.challenge.alpha = 1;
//    [Animations fadeIn:self.runButton andAnimationDuration:1 toAlpha:1 andWait:NO];
//    [Animations fadeIn:self.challenge andAnimationDuration:1 toAlpha:1 andWait:YES];
    self.historyButton.alpha =1;
    self.settingButton.alpha = 1;
    [self.historyButton slideInFrom:kFTAnimationRight duration:0.5 delegate:self];
    [self.settingButton slideInFrom:kFTAnimationLeft duration:0.5 delegate:self];
//    [Animations fadeIn:self.settingButton andAnimationDuration:1.5 toAlpha:1 andWait:YES];
    
    [Animations moveRight:self.weatherInfoButtonView andAnimationDuration:0.4 andWait:NO andLength:110];
    [Animations moveLeft:self.userInfoView andAnimationDuration:0.4 andWait:YES andLength:220];

    [Animations moveLeft:self.weatherInfoButtonView andAnimationDuration:0.1 andWait:NO andLength:10];
    [Animations moveRight:self.userInfoView andAnimationDuration:0.1 andWait:YES andLength:10];
}

- (IBAction)weatherPopAction:(id)sender{
    [self sendNotification:weatherInformation];
//    [self charactorAnimation];
}

- (IBAction)normalRunAction:(id)sender {
}

- (IBAction)challengeRunAction:(id)sender{
}
@end
