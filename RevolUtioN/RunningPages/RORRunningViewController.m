//
//  RORGetReadyViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORRunningViewController.h"
#import "TBCycleView.h"

#define SCALE_SMALL CGRectMake(50,70,220,188)
#define COLOR_BTN_BLUE [UIColor colorWithRed:0 green:183.0/255.0 blue:238.0/255.0 alpha:1]


@interface RORRunningViewController ()

@end

@implementation RORRunningViewController
//@synthesize locationManager, motionManager;
@synthesize timerCount;
@synthesize labelTime, labelTimeTag, labelSpeed, labelDistance, labelDistanceTag, labelCalorie, labelTimeTarget, labelTimeTagTarget, labelDistanceTarget, labelDistanceTagTarget;
@synthesize btnBack, btnSound, btnStart, btnEnd,btnEndContainer, btnWarmUp, btnShowMap, btnCenterMap, btnStartTarget;
@synthesize viewRouteLine;
@synthesize record;
@synthesize doCollect;
@synthesize kalmanFilter, inDistance;
@synthesize viewMapContainer, mapView, viewCover, fadeContainer;

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
    [RORUtils setFontFamily:ENG_PRINT_FONT forView:self.view andSubViews:YES];
}

//initial all when view appears
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self controllerInit];
    
    //init bar status
    navigationBarHiddenPreviousStatus = self.navigationController.navigationBarHidden;
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    //reverse bar status
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count>0) {
        ((UIViewController*)[viewControllers objectAtIndex:viewControllers.count-1]).navigationController.navigationBarHidden = navigationBarHiddenPreviousStatus;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
    }
}

-(void)controllerInit{
    self.viewCover.alpha = 0;
    
    self.mapView.delegate = self;
    [Animations moveDown:viewMapContainer andAnimationDuration:0 andWait:NO andLength:viewMapContainer.frame.size.height];
    [btnBack addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnStart setEnabled:NO];
    [btnStart setTitle:SEARCHING_LOCATION forState:UIControlStateNormal];
    [btnStart setAlpha:0.5];
    UIImage *image = [UIImage imageNamed:@"green_btn_bg.png"];
    [btnStart setBackgroundImage:image forState:UIControlStateNormal];
    
    [btnEnd setDelegate:self];
    btnEnd.persentage = 0.0;
    
    labelTime.text = [RORUtils transSecondToStandardFormat:0];
    labelSpeed.text = [RORUserUtils formatedSpeed:0];
    labelDistance.text = [RORUtils formatedDistance:0];
//    self.stepLabel.text = @"0";
//    mapView.frame = SCALE_SMALL;
    
    doCollect = NO;
    
    routePoints = [[NSMutableArray alloc]init];
    
    btnShowMap.layer.cornerRadius = btnShowMap.frame.size.width/2;
    btnCenterMap.layer.cornerRadius = btnCenterMap.frame.size.width/2;
    btnStart.layer.cornerRadius = btnStart.frame.size.width/2;
    btnWarmUp.layer.cornerRadius = btnWarmUp.frame.size.width/2;
    
    statusBarPreviousStatus = [UIApplication sharedApplication].statusBarStyle;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    labelDistanceMoveOffset = labelDistance.center.y - labelDistanceTarget.center.y;
    labelDistanceTagMoveOffsetX = labelDistanceTag.center.x - labelDistanceTagTarget.center.x;
    labelDistanceTagMoveOffsetY = labelDistanceTag.center.y - labelDistanceTagTarget.center.y;
    labelTimeMoveOffset = labelTime.center.y - labelTimeTarget.center.y;
    labelTimeTagMoveOffsetX = labelTimeTag.center.x - labelTimeTagTarget.center.x;
    labelTimeTagMoveOffsetY = labelTimeTag.center.y - labelTimeTagTarget.center.y;
    btnStartMoveOffset = btnStart.center.x - btnStartTarget.center.x;
    
    isSoundOn = YES;
    
}

-(void)navigationInit{
    //    [mapView setUserTrackingMode:MKUserTrackingModeFollow];
    [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [mapView removeOverlays:[mapView overlays]];

    MKwasFound = NO;
    timerCount = 0;
    distance = 0;
    isStarted = NO;
}

-(void)LogDeviceStatus{
    // 加速度器的检测
    if ([motionManager isAccelerometerAvailable]){
        NSLog(@"Accelerometer is available.");
    } else{
        NSLog(@"Accelerometer is not available.");
    }
    if ([motionManager isAccelerometerActive]){
        NSLog(@"Accelerometer is active.");
    } else {
        NSLog(@"Accelerometer is not active.");
    }
    
    // 陀螺仪的检测
    if([motionManager isGyroAvailable]){
        NSLog(@"Gryro is available.");
    } else {
        NSLog(@"Gyro is not available.");
    }
    if ([motionManager isGyroActive]){
        NSLog(@"Gryo is active.");
        
    } else {
        NSLog(@"Gryo is not active.");
    }
    
    // deviceMotion的检测
    if([motionManager isDeviceMotionAvailable]){
        NSLog(@"DeviceMotion is available.");
    } else {
        NSLog(@"DeviceMotion is not available.");
    }
    if ([motionManager isDeviceMotionActive]){
        NSLog(@"DeviceMotion is active.");
        
    } else {
        NSLog(@"DeviceMotion is not active.");
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self navigationInit];
}

- (IBAction)btnBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSoundAction:(id)sender {
    if (isSoundOn){
        isSoundOn = NO;
        [btnSound setBackgroundImage:[UIImage imageNamed:@"icon_sound_off.png"] forState:UIControlStateNormal];
    } else {
        isSoundOn = YES;
        [btnSound setBackgroundImage:[UIImage imageNamed:@"icon_sound_on.png"] forState:UIControlStateNormal];
    }
}


- (IBAction)switchMap:(id)sender{
    [btnShowMap setEnabled:NO];

    float aniDuration = 0.5;
    
    //TODO: data animation
    [Animations zoomOut:labelDistance toX:0.6 toY:0.6 andAnimationDuration:aniDuration andWait:NO];
    [Animations moveUp:labelDistance andAnimationDuration:aniDuration andWait:NO andLength:labelDistanceMoveOffset];
    [Animations moveUp:labelDistanceTag andAnimationDuration:aniDuration andWait:NO andLength:labelDistanceTagMoveOffsetY];
    [Animations moveLeft:labelDistanceTag andAnimationDuration:aniDuration andWait:NO andLength:labelDistanceTagMoveOffsetX];
    [Animations zoomOut:labelTime toX:0.8 toY:0.8 andAnimationDuration:aniDuration andWait:NO];
    [Animations moveUp:labelTime andAnimationDuration:aniDuration andWait:NO andLength:labelTimeMoveOffset];
    [Animations moveUp:labelTimeTag andAnimationDuration:aniDuration andWait:NO andLength:labelTimeTagMoveOffsetY];
    [Animations moveLeft:labelTimeTag andAnimationDuration:aniDuration andWait:NO andLength:labelTimeTagMoveOffsetX];
    [Animations fadeOut:fadeContainer andAnimationDuration:aniDuration fromAlpha:1 andWait:NO];
    
    [Animations moveUp:viewMapContainer andAnimationDuration:aniDuration andWait:YES andLength:viewMapContainer.frame.size.height];
}

- (IBAction)closeMap:(id)sender{
    [btnShowMap setEnabled:YES];

    float aniDuration = 0.5;

    //TODO: data animation
    [Animations zoomBack:labelDistance fromX:0.6 fromY:0.6 andAnimationDuration:aniDuration andWait:NO];
    [Animations moveDown:labelDistance andAnimationDuration:aniDuration andWait:NO andLength:labelDistanceMoveOffset];
    [Animations moveDown:labelDistanceTag andAnimationDuration:aniDuration andWait:NO andLength:labelDistanceTagMoveOffsetY];
    [Animations moveRight:labelDistanceTag andAnimationDuration:aniDuration andWait:NO andLength:labelDistanceTagMoveOffsetX];
    [Animations zoomBack:labelTime fromX:0.6 fromY:0.6 andAnimationDuration:aniDuration andWait:NO];
    [Animations moveDown:labelTime andAnimationDuration:aniDuration andWait:NO andLength:labelTimeMoveOffset];
    [Animations moveDown:labelTimeTag andAnimationDuration:aniDuration andWait:NO andLength:labelTimeTagMoveOffsetY];
    [Animations moveRight:labelTimeTag andAnimationDuration:aniDuration andWait:NO andLength:labelTimeTagMoveOffsetX];
    [Animations fadeIn:fadeContainer andAnimationDuration:aniDuration toAlpha:1 andWait:NO];
    
    [Animations moveDown:viewMapContainer andAnimationDuration:aniDuration andWait:YES andLength:viewMapContainer.frame.size.height];
}

////center the map to userLocation of MKMapView
- (IBAction)center_map:(id)sender{
    CLLocation *loc = [mapView userLocation].location;
    float zoomLevel = 0.005;
    MKCoordinateRegion region = MKCoordinateRegionMake(loc.coordinate, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [mapView setRegion:[mapView regionThatFits:region] animated:NO];

}

-(void)createAnnotationWithCoords:(CLLocationCoordinate2D) coords withTitle:(NSString *)title andSubTitle:(NSString *) subTitle {
    RORMapAnnotation *annotation = [[RORMapAnnotation alloc] initWithCoordinate:
                                    coords];
    annotation.title = title;
    annotation.subtitle = subTitle;
    [mapView addAnnotation:annotation];
}

- (IBAction)warmUpAction:(id)sender{
    //TODO:warm up
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [self setLabelDistance:nil];
    [self setLabelTime:nil];
    [self setLabelSpeed:nil];
    [self setBtnStart:nil];
    [self setBtnEnd:nil];
    [self setViewRouteLine:nil];
    [self setStartTime:nil];
    [self setEndTime:nil];
    [self setRecord:nil];
    
    [self setViewCover:nil];
    [self setBtnSave:nil];
    [self setDataContainer:nil];
    [super viewDidUnload];
}

- (IBAction)btnStartAction:(id)sender {
    float btnAnimationDuration = 0.3;
    
    if (!isStarted){
        isStarted = YES;
        if (self.startTime == nil){
            self.startTime = [NSDate date];
            
            [(RORAppDelegate *)[[UIApplication sharedApplication] delegate] setRunningStatus:YES];
            
//            [[UIApplication sharedApplication] setIdleTimerDisabled: YES];

//            [btnEnd setTitle:FINISH_RUNNING_BUTTON forState:UIControlStateNormal];
//            [btnEnd setBackgroundColor:[UIColor clearColor]];
//            [btnEnd setBackgroundImage:[UIImage imageNamed:@"icon_end.png"] forState:UIControlStateNormal];
//            [btnEnd removeTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//            [btnEnd addTarget:self action:@selector(btnEndAction:) forControlEvents:UIControlEventTouchUpInside];
            
            //init inertia navigation
            [self initNavi];
            
            [self startDeviceMotion];
            
            //the first point after started
            [self initOffset:[mapView userLocation]];
//            [sound play];
//            [countDownView show];
        }
        //init former location
        latestUserLocation = [self getNewRealLocation];
        formerLocation = latestUserLocation;
        [routePoints addObject:formerLocation];
        [self drawLineWithLocationArray:routePoints];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(timerDot) userInfo:nil repeats:YES];
        repeatingTimer = timer;
        
        if (![audioPlayer isPlaying]){
            [self startFakeSound];
        }
        
        UIImage *image = [UIImage imageNamed:@"icon_pause.png"];
        [btnStart setBackgroundImage:image forState:UIControlStateNormal];
        [btnStart setBackgroundColor:[UIColor clearColor]];
        [btnStart setTitle:PAUSSE_RUNNING_BUTTON forState:UIControlStateNormal];
        [Animations moveLeft:btnStart andAnimationDuration:btnAnimationDuration andWait:NO andLength:btnStartMoveOffset];
        
//        [btnEnd setEnabled:NO];
        [Animations fadeOut:btnEndContainer andAnimationDuration:btnAnimationDuration fromAlpha:btnEndContainer.alpha andWait:NO];
        
        [btnWarmUp setAlpha:0];
        [Animations fadeOut:btnWarmUp andAnimationDuration:btnAnimationDuration fromAlpha:btnWarmUp.alpha andWait:NO];
        
        [btnBack setEnabled:NO];
        [btnBack setAlpha:0];
    } else {
        [self stopTimer];
        
        [self stopFakeSound];
        
        [btnStart setBackgroundImage:NULL forState:UIControlStateNormal];
        [btnStart setTitle:CONTINUE_RUNNING_BUTTON forState:UIControlStateNormal];
        [btnStart setBackgroundColor:COLOR_BTN_BLUE];
        [Animations moveRight:btnStart andAnimationDuration:btnAnimationDuration andWait:NO andLength:btnStartMoveOffset];
        
//        [btnEnd setEnabled:YES];
        [Animations fadeIn:btnEndContainer andAnimationDuration:btnAnimationDuration toAlpha:1 andWait:NO];
    }
    //    [[NSRunLoop  currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
}

- (void)initNavi{
    [super initNavi];
    [mapView removeOverlays:[mapView overlays]];
}

- (void)inertiaNavi{
    [super inertiaNavi];
    
//    self.stepLabel.text = [NSString stringWithFormat:@"%d", stepCounting.counter];
//    self.avgTimePerStep.text = [NSString stringWithFormat:@"%.2f s", duration/((double)stepCounting.counter)];
//    self.avgDisPerStep.text = [NSString stringWithFormat:@"%.2f m", distance/((double)stepCounting.counter)];
}

- (void)timerDot{
    [self timerDotCommon];
    doCollect = YES;
    
    timerCount++;
    duration = timerCount * TIMER_INTERVAL;
    // currently, only do running status judgement here.
    [self inertiaNavi];
    
    NSInteger intTime = (NSInteger)duration;
    if (duration - intTime < 0.00001){ //1 second
        [self timerSecondDot];
    }

    labelTime.text = [RORUtils transSecondToStandardFormat:duration];
}

-(void)timerSecondDot{
    [super timerSecondDot];
    [self pushPoint];
    labelDistance.text = [RORUtils formatedDistance:distance];
    labelSpeed.text = [RORUserUtils formatedSpeed:(double)(currentSpeed*3.6)];
    labelCalorie.text = [NSString stringWithFormat:@"%d",[self calculateCalorie:distance].intValue];
}

- (void)pushPoint{
    CLLocation *currentLocation = [self getNewRealLocation];
    double deltaDistance = [formerLocation distanceFromLocation:currentLocation];
    NSLog(@"[%@, %@], delta_d = %f", formerLocation, currentLocation, deltaDistance);
    if (formerLocation != currentLocation && deltaDistance>MIN_PUSHPOINT_DISTANCE){
        //calculate real-time speed
        currentSpeed = deltaDistance / timeFromLastLocation;//[INDeviceStatus getSpeedVectorBetweenLocation1:formerLocation andLocation2:currentLocation deltaTime:timeFromLastLocation];
        timeFromLastLocation = 0;
        
        NSLog(@"%f",deltaDistance);
        distance += [formerLocation distanceFromLocation:currentLocation];
        formerLocation = currentLocation;
        
        [routePoints addObject:currentLocation];
        [self drawLineWithLocationArray:routePoints];
        
        //记录每KM平均速度
        [self pushAvgSpeedPerKM];
    }
}

- (IBAction)btnEndAction:(id)sender {
    [self stopTimer];

    [btnStart setTitle:CONTINUE_RUNNING_BUTTON forState:UIControlStateNormal];
    
    if (distance > 30){
        [self.btnSave setEnabled:YES];
        [self.btnSave setTitle:@"保存" forState:UIControlStateNormal];
        [self.btnSave setAlpha:1];
    } else {
        [self.btnSave setEnabled:NO];
        [self.btnSave setTitle:@"你确定已经尽力了？" forState:UIControlStateNormal];
        [self.btnSave setAlpha:0.7];
    }
    [Animations fadeIn:viewCover andAnimationDuration:0.3 toAlpha:1 andWait:NO];
    
}

- (IBAction)btnCoverInside:(id)sender {
    [Animations fadeOut:viewCover andAnimationDuration:0.3 fromAlpha:1 andWait:NO];
    btnEnd.persentage = 0.0;
}

- (IBAction)btnSaveRunTouched:(id)sender {
    [self startIndicator:self];
}
- (IBAction)btnSaveRunTouchCanceled:(id)sender {
    [self endIndicator:self];
}

- (IBAction)btnSaveRun:(id)sender {

    [self stopUpdates];
    
    if (self.endTime == nil)
        self.endTime = [NSDate date];
    
    [self prepareForQuit];
    [self saveRunInfo];
    [self performSegue];
    [self endIndicator:self];
}

-(void)performSegue{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)prepareForQuit{
    [(RORAppDelegate *)[[UIApplication sharedApplication] delegate] setRunningStatus:NO];
    
    [repeatingTimer invalidate];
    repeatingTimer = nil;
}

- (IBAction)btnDeleteRunHistory:(id)sender {
    [self prepareForQuit];
    [self performSegue];
}

- (void)saveRunInfo{
    [self creatRunningHistory];
    
    [RORRunHistoryServices saveRunInfoToDB:runHistory];
//    //upload
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        BOOL updated = [RORRunHistoryServices uploadRunningHistories];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if(updated){
//                [self sendSuccess:SYNC_DATA_SUCCESS];
//            }
//            else{
//                [self sendAlart:SYNC_DATA_FAIL];
//            }
//        });
//    });
}

-(void)creatRunningHistory{
    runHistory = [User_Running_History intiUnassociateEntity];
    runHistory.distance = [NSNumber numberWithDouble:distance];
    runHistory.duration = [NSNumber numberWithDouble:duration];
    runHistory.avgSpeed = [NSNumber numberWithDouble:(double)(distance/duration*3.6)];
    runHistory.valid = [self isValidRun:stepCounting.counter / 0.8];
    runHistory.missionRoute = [RORDBCommon getStringFromRoutes:routes];
    
    runHistory.missionDate = [NSDate date];
    runHistory.missionEndTime = self.endTime;
    runHistory.missionStartTime = self.startTime;
    runHistory.userId = [RORUserUtils getUserId];
    runHistory.missionTypeId = [NSNumber numberWithInteger:NormalRun];
    runHistory.spendCarlorie = [self calculateCalorie:distance];
    runHistory.runUuid = [RORUtils uuidString];
    runHistory.uuid = [RORUserUtils getUserUuid];
    runHistory.steps = [NSNumber numberWithInteger:stepCounting.counter / 0.8];
    runHistory.experience =[self calculateExperience:runHistory];
    runHistory.scores =[self calculateScore:runHistory];
    runHistory.extraExperience =[NSNumber  numberWithDouble:0];
    runHistory.speedList = [RORDBCommon getStringFromSpeedList:avgSpeedPerKMList];
    
    if(runHistory.valid.integerValue != 1 || runHistory.userId.integerValue < 0){
        runHistory.experience =[NSNumber numberWithDouble:0];
        runHistory.scores =[NSNumber  numberWithDouble:0];
    }
    
    NSLog(@"%@", runHistory);
    record = runHistory;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setRecord:)]){
        [destination setValue:record forKey:@"record"];
    }
}

- (void)drawLineWithLocationArray:(NSArray *)locationArray
{
    //    [self updateLocation];
    if (routeLine!=nil){
        [mapView removeOverlay:routeLine];
    }
    
    int pointCount = [locationArray count];
    //debug
//    NSLog(@"%d", pointCount);
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locationArray objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
    }
    
    routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
//    self.viewRouteLineShadow = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    
    //    [mapView setVisibleMapRect:[routeLine boundingMapRect]];
//    [mapView addOverlay:self.viewRouteLineShadow];
    [mapView addOverlay:routeLine];
    free(coordinateArray);
    coordinateArray = NULL;
}


#pragma mark - MKMapViewDelegate


-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!MKwasFound){
        MKwasFound = YES;
        [self center_map:self];
        formerCenterMapLocation = [self getNewRealLocation];
        [btnStart setTitle:START_RUNNING_BUTTON forState:UIControlStateNormal];
        [btnStart setAlpha:1];
        [self.btnStart setEnabled:YES];
    }
    if ([formerCenterMapLocation distanceFromLocation:[self getNewRealLocation]]>20){
        [self center_map:self];
        formerCenterMapLocation = [self getNewRealLocation];
        //to-do
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKOverlayView* overlayView = nil;
    
    if(overlay == routeLine)
    {
        //if we have not yet created an overlay view for this overlay, create it now.
        //        if(nil == self.viewRouteLine)
        //        {
        self.viewRouteLine = [[MKPolylineView alloc] initWithPolyline:routeLine];
        //        self.viewRouteLine.fillColor = [UIColor colorWithRed:223 green:8 blue:50 alpha:1];
        self.viewRouteLine.strokeColor = [UIColor colorWithRed:(46.0/255.0) green:(170.0/255.0) blue:(218.0/255.0) alpha:1];
        self.viewRouteLine.lineWidth = 10;
        //        }
        overlayView = self.viewRouteLine;
    }

    return overlayView;
    
}


@end
