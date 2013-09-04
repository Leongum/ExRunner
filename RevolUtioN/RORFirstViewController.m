//
//  RORFirstViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-4-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORFirstViewController.h"

#define WEATHER_WINDOW_INITIAL_FRAME CGRectMake(-100, 80, 100, 140)
#define RUN_BUTTON_FRAME_NORMAL CGRectMake(92, 100, 136, 60)
#define RUN_BUTTON_FRAME_RATINA CGRectMake(92, 130, 136, 60)
#define CHALLENGE_BUTTON_FRAME_NORMAL CGRectMake(0, 170, 320, 94)
#define CHALLENGE_BUTTON_FRAME_RATINA CGRectMake(0, 237, 320, 94)


@interface RORFirstViewController ()

@end

@implementation RORFirstViewController
@synthesize weatherSubView;
@synthesize weatherInfoButtonView;
@synthesize locationManager;

NSInteger expanded = 0;
BOOL isWeatherButtonClicked = false;
NSInteger centerLoc =-10000;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [RORUtils setFontFamily:@"FZKaTong-M19S" forView:self.view andSubViews:YES];

    weatherSubView.frame = WEATHER_WINDOW_INITIAL_FRAME;
    //init topbar's gesture listeners
    UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [weatherSubView addGestureRecognizer:t];
    
//    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
//    [weatherSubView addGestureRecognizer:panGes];
        
    //初始化按钮位置
    [self initControlsLayout];
    [self initLocationServcie];
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
    NSLog(@"ToLocation:%f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    wasFound = YES; 
    if (wasFound){
        [locationManager stopUpdatingLocation];
        [self getCitynameByLocation];
    }
//    NSLog(@"Device did %f meters move.", [self.latestUserLocation getDistanceFrom:newLocation]);
//    self.latestUserLocation = [self transToRealLocation:newLocation];
    
}

- (void)initControlsLayout{
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
        self.userInfoView.alpha = 1;
        
        User_Base *userInfo = [RORUserServices fetchUser:[RORUserUtils getUserId]];
        self.usernameLabel.text = userInfo.nickName;
        self.levelLabel.text = [NSString stringWithFormat:@"等级：%@", userInfo.attributes.level];
        self.scoreLabel.text = [NSString stringWithFormat:@"积分：%@", userInfo.attributes.scores];
    } else {
        self.userInfoView.alpha = 0;
        self.loginButton.alpha = 1;
    }
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initPageData];
}

- (IBAction)segueToLogin:(id)sender{
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
}

-(void)segueToInfo{
    [self performSegueWithIdentifier:@"userInfoSegue"sender:self];
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
                int temp = INT16_MAX;
                int pm25 = INT16_MAX;
                if (weatherInfo != nil){
                    temp = [[weatherInfo objectForKey:@"temp"] integerValue];
                    self.lbTemperature.text = [NSString stringWithFormat:@"%d℃",temp];
                    self.lbWind.text = [NSString stringWithFormat:@"%@%@",[weatherInfo objectForKey:@"WD"],[weatherInfo objectForKey:@"WS"]];
                    self.lbLocation.text = cityName;
                }
                if(pm25info != nil){
                    pm25 = [[pm25info objectForKey:@"pm2_5"] integerValue];
                    self.lbPM.text = [NSString stringWithFormat:@"PM2.5：%d%@",pm25,[pm25info objectForKey:@"quality"]];
                }
                int index = 60;
                if(temp < 38 && pm25 < 300){
                    index = (100-pm25/3)*0.6 +(100-fabs(temp - 22)*5)*0.4;
                }
                self.lbTotal.text = [NSString stringWithFormat:@"%d",index];
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

-(void) panAction:(UIPanGestureRecognizer*) recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        centerLoc = weatherSubView.center.y;
    }
    CGPoint translation = [recognizer translationInView:weatherSubView];
    [self weatherDragView:translation.y];

    CGContextRef gccontext = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:gccontext];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.6];
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        int trans = weatherSubView.center.y - centerLoc;
        if (trans>0 && expanded == 0 ){
            [self weatherInView];
            expanded = 1;
        } else if (trans<0 && expanded == 1 ){
            [self weatherPopView];
            expanded = 0;
        }
    }
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];

    [recognizer setTranslation:CGPointZero inView:weatherSubView];
}

-(void) singleTap:(UITapGestureRecognizer*) tap {
    [self weatherPopView];

//    if (expanded) {
//        [self weatherPopView];
//        expanded = 0;
//    }
//    else {
//        [self weatherInView];
//        expanded = 1;
//    }

//    NSLog(@"single tap: %f %f", p.x, p.y );
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {

    [self setWeatherSubView:nil];
    [self setWeatherInfoButtonView:nil];
    [self setUserName:nil];
    [self setUserId:nil];
    
    [self setLbTemperature:nil];
    [self setLbWind:nil];
    [self setRunButton:nil];
    [self setChallenge:nil];
    [self setLbUV:nil];
    [self setLbPM:nil];
    [self setLbLocation:nil];
    [self setLbTotal:nil];
    [self setUsernameLabel:nil];
    [self setLevelLabel:nil];
    [self setScoreLabel:nil];
    [self setUserInfoView:nil];
    [self setLoginButton:nil];
    [super viewDidUnload];
}

- (void)weatherPopView{
    CGContextRef gccontext = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:gccontext];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];
    weatherSubView.frame = WEATHER_WINDOW_INITIAL_FRAME;
    weatherInfoButtonView.tintColor = nil;
    expanded = 0;

    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

- (void)weatherDragView : (int)transition{
    UIView* localView = weatherSubView;
    static int TOP = -123;
    static int BOTTOM = 0;
    
    if (localView.frame.origin.y + transition>BOTTOM)
        localView.center = CGPointMake(localView.center.x,(localView.frame.size.height)/2); //61.5
    else if (localView.frame.origin.y + transition<TOP)
        localView.center = CGPointMake(localView.center.x,(localView.frame.size.height)/2+TOP);//25.5
    else localView.center = CGPointMake(localView.center.x,
                                           localView.center.y + transition);
}

- (void)weatherInView{
    CGContextRef gccontext = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:gccontext];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];

    weatherSubView.frame = CGRectMake(2, 0, 100, 120);
    weatherInfoButtonView.tintColor = [UIColor colorWithRed:0.25 green:0.4 blue:0.72 alpha:0.0];
    expanded = 1;

    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}
- (void)weatherInView1{
    CGContextRef gccontext = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:gccontext];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];
    
    weatherSubView.frame = CGRectMake(2, 0, 100, 120);
//    weatherInfoButtonView.tintColor = [UIColor colorWithRed:0.25 green:0.4 blue:0.72 alpha:0.0];
    expanded = 1;
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

- (IBAction)weatherInfoAction:(id)sender {
    if (weatherSubView.frame.origin.x < -10){
//        [self weatherInView];
//        [UIView beginAnimations:@"animation" context:nil];
//        [UIView setAnimationDuration:1];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.testView cache:YES];
//        UIImage *image = [UIImage imageNamed:@"graybutton_bg.png"];
//        [self.testView setImage:image];
//        [UIView commitAnimations];
        
        [Animations moveRight:weatherSubView andAnimationDuration:0.1 andWait:YES andLength:100];
        [Animations moveLeft:weatherSubView andAnimationDuration:0.1 andWait:NO andLength:10];
        
    } else {
        [self weatherPopView];
//        [UIView beginAnimations:@"animation" context:nil];
//        [UIView setAnimationDuration:1];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.testView cache:YES];
//        UIImage *image = [UIImage imageNamed:@"redbutton_bg.png"];
//        [self.testView setImage:image];
//        [UIView commitAnimations];
    }
}

- (IBAction)normalRunAction:(id)sender {
}

- (IBAction)challengeRunAction:(id)sender{
}
@end
