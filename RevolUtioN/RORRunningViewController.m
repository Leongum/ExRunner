//
//  RORGetReadyViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORRunningViewController.h"
#import "RORMapPoint.h"
#import "User_Running_History.h"
#import "RORAppDelegate.h"
#import "RORMapAnnotation.h"
#import "RORUtils.h"
#import "RORDBCommon.h"
#import "RORMacro.h"

#define SCALE_SMALL CGRectMake(0,0,320,155)


@interface RORRunningViewController ()

@end

@implementation RORRunningViewController
@synthesize locationManager, motionManager;
@synthesize mapView, expandButton, collapseButton, formerLocation, count, repeatingTimer, timerCount, isStarted, latestUserLocation, offset, latestINLocation;
@synthesize timeLabel, speedLabel, distanceLabel, startButton, endButton;
@synthesize distance, routePoints, routeLine, routeLineView;
@synthesize record;
@synthesize doCollect;
@synthesize kalmanFilter, OldVn, stepCounting, inDistance;
@synthesize avgDisPerStep, avgTimePerStep;

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
}

//initial all when view appears
- (void)viewDidAppear:(BOOL)animated{
    [self controllerInit];
    [self navigationInit];
}

-(void)controllerInit{
    self.mapView.delegate = self;
    [startButton setTitle:@"开始" forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"graybutton_bg.png"];
    [startButton setBackgroundImage:image forState:UIControlStateNormal];
    [endButton setEnabled:NO];
    routePoints = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回首页";
    backItem.action = @selector(backToMain:);
    self.navigationItem.backBarButtonItem = backItem;
    
    collapseButton.alpha = 0;
    
    timeLabel.text = @"00:00:00";
    speedLabel.text = @"0.00 m/s";
    distanceLabel.text = @"0 m";
    self.stepLabel.text = @"0";
    mapView.frame = SCALE_SMALL;
    
    doCollect = NO;
}

-(void)navigationInit{
    //    [mapView setUserTrackingMode:MKUserTrackingModeFollow];
    [mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    [mapView removeOverlays:[mapView overlays]];
    motionManager = [[CMMotionManager alloc] init];
    wasFound = NO;
    count = 0;
    timerCount = 0;
    distance = 0;
    offset.latitude = 0.0;
    offset.longitude = 0.0;
    isStarted = NO;
    
    //init inertia navigation distance
    inDistance.v1 = 0;
    inDistance.v2 = 0;
    inDistance.v3 = 0;
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

-(void)backToMain:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startDeviceLocation{
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    locationManager.distanceFilter = 1;
    // start the compass
    [locationManager startUpdatingLocation];
    
	if ([CLLocationManager headingAvailable] == NO) {
		// No compass is available. This application cannot function without a compass,
        // so a dialog will be displayed and no magnetic data will be measured.
        NSLog(@"Magnet is not available.");
	} else {
        // heading service configuration
        locationManager.headingFilter = kCLHeadingFilterNone;
        
        [locationManager startUpdatingHeading];
    }
}

- (void)startDeviceMotion
{
    //	motionManager = [[CMMotionManager alloc] init];
	// Tell CoreMotion to show the compass calibration HUD when required to provide true north-referenced attitude
	motionManager.showsDeviceMovementDisplay = YES;
    
	motionManager.deviceMotionUpdateInterval = delta_T;
    motionManager.accelerometerUpdateInterval = delta_T;
	
	// New in iOS 5.0: Attitude that is referenced to true north
    if (motionManager.isMagnetometerAvailable){
        [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];
        //        [motionManager startAccelerometerUpdates];
        NSLog(@"start updating device motion using X true north Z vertical reference frame.");
    } else {
        [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical];
        //        [motionManager startAccelerometerUpdates];
        NSLog(@"start updating device motion using Z vertical reference frame.");
    }
}

- (void)stopUpdates
{
    if ([motionManager isDeviceMotionActive] == YES) {
        [motionManager stopDeviceMotionUpdates];
    }
    [locationManager stopUpdatingLocation];
    [locationManager stopUpdatingHeading];
}

-(void)awakeFromNib {
    [self startDeviceLocation];
}

- (CLLocation *)transToRealLocation:(CLLocation *)orginalLocation{
    CLLocation *absoluteLocation = [[CLLocation alloc] initWithLatitude:orginalLocation.coordinate.latitude + offset.latitude longitude:orginalLocation.coordinate.longitude + offset.longitude];
    return absoluteLocation;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"ToLocation:%f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    NSLog(@"Device did %f meters move.", [self.latestUserLocation getDistanceFrom:newLocation]);
    self.latestUserLocation = [self transToRealLocation:newLocation];
    
}

-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
 
}

////center the route line
//- (void)center_map{
//    MKCoordinateRegion region;
//    CLLocationDegrees maxLat = -90;
//    CLLocationDegrees maxLon = -180;
//    CLLocationDegrees minLat = 90;
//    CLLocationDegrees minLon = 180;
//
//    for (int i=0; i<routePoints.count; i++){
//        CLLocation *currentLocation = [routePoints objectAtIndex:i];
//        if (currentLocation.coordinate.latitude > maxLat)
//            maxLat = currentLocation.coordinate.latitude;
//        if (currentLocation.coordinate.longitude > maxLon)
//            maxLon = currentLocation.coordinate.longitude;
//        if (currentLocation.coordinate.latitude < minLat)
//            minLat = currentLocation.coordinate.latitude;
//        if (currentLocation.coordinate.longitude < minLon)
//            minLon = currentLocation.coordinate.longitude;
//    }
//    region.center.latitude = (maxLat + minLat)/2;
//    region.center.longitude = (maxLon + minLon)/2;
//    region.span.latitudeDelta = maxLat - minLat ;
//    region.span.longitudeDelta = maxLon - minLon;
//
//    [mapView setRegion:region animated:YES];
//}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

-(void)createAnnotationWithCoords:(CLLocationCoordinate2D) coords withTitle:(NSString *)title andSubTitle:(NSString *) subTitle {
    RORMapAnnotation *annotation = [[RORMapAnnotation alloc] initWithCoordinate:
                                    coords];
    annotation.title = title;
    annotation.subtitle = subTitle;
    [mapView addAnnotation:annotation];
}

- (BOOL) compareLocation:(CLLocationCoordinate2D) locA withLocation:(CLLocationCoordinate2D) locB{
    float lat = locA.latitude - locB.latitude;
    float lon = locA.longitude - locB.longitude;
    float lat2 = lat * lat;
    float lon2 = lon * lon;
    if (lat2 + lon2 > 1e-8)
        return YES;
    return NO;
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [self setDistanceLabel:nil];
    [self setTimeLabel:nil];
    [self setSpeedLabel:nil];
    [locationManager stopUpdatingLocation];
    [self setExpandButton:nil];
    [self setStartButton:nil];
    [self setEndButton:nil];
    [self setCollapseButton:nil];
    [self setRoutePoints:nil];
    [self setRouteLine:nil];
    [self setRouteLineView:nil];
    [self setStartTime:nil];
    [self setEndTime:nil];
    [self setRecord:nil];
    
    [self setStepLabel:nil];
    [self setAvgDisPerStep:nil];
    [self setAvgTimePerStep:nil];
    [super viewDidUnload];
}

- (IBAction)expandAction:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.6];
    
    expandButton.alpha = 0;
    collapseButton.alpha = 0.7;
    mapView.frame = [ UIScreen mainScreen ].bounds;
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
    
}

- (IBAction)collapseAction:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];
    
    collapseButton.alpha = 0;
    expandButton.alpha = 0.7;
    mapView.frame = SCALE_SMALL;
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
    
}

- (void)initOffset{
    MKUserLocation *userLocation = [mapView userLocation];
    CLLocation *cl = [locationManager location];
    offset.latitude = userLocation.coordinate.latitude - cl.coordinate.latitude;
    offset.longitude = userLocation.coordinate.longitude - cl.coordinate.longitude;
}

- (IBAction)startButtonAction:(id)sender {
    if (!isStarted){
        isStarted = YES;
        if (self.startTime == nil){
            self.startTime = [NSDate date];
            [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
            
            //init inertia navigation
            [self initNavi];
            
            [self startDeviceMotion];
            
            //the first point after started
            [self initOffset];
            self.latestUserLocation = [self transToRealLocation:latestUserLocation];
            self.formerLocation = self.latestUserLocation;//[locationManager location];
            [routePoints addObject:self.latestUserLocation];
            [self drawLineWithLocationArray:routePoints];
            
            CLGeocoder *geocoder = [[CLGeocoder alloc]init];
            [geocoder reverseGeocodeLocation:self.latestUserLocation completionHandler:^(NSArray *placemarks, NSError *error){
                CLPlacemark *placemark = (CLPlacemark *)[placemarks objectAtIndex:0];
                NSLog(@"%@, %@, %@, %@, %@, %@", placemark.country, placemark.administrativeArea, placemark.subLocality, placemark.thoroughfare, placemark.subThoroughfare, placemark.name);
            }];
            //            [self pushPoint];
        }
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(timerDot) userInfo:nil repeats:YES];
        self.repeatingTimer = timer;
        UIImage *image = [UIImage imageNamed:@"redbutton_bg.png"];
        [startButton setBackgroundImage:image forState:UIControlStateNormal];
        [startButton setTitle:@"暂停" forState:UIControlStateNormal];
        [endButton setEnabled:YES];
    } else {
        [repeatingTimer invalidate];
        self.repeatingTimer = nil;
        isStarted = NO;
        
        [startButton setTitle:@"继续" forState:UIControlStateNormal];
    }
    //    [[NSRunLoop  currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
}

- (void)initNavi{
    OldVn.v1 = 0;
    OldVn.v2 = 0;
    OldVn.v3 = 0;
    
    [mapView removeOverlays:[mapView overlays]];
    //    [routePoints addObject:initialLocation];
    //init kalman filter
    kalmanFilter = [[INKalmanFilter alloc]initWithCoordinate:[locationManager location].coordinate];
    stepCounting = [[INStepCounting alloc]init];
    //    [self drawLineWithLocationArray:routePoints];
    //    [self center_map];
}

- (void)inertiaNavi{
    CMDeviceMotion *deviceMotion = motionManager.deviceMotion;
    INDeviceStatus *newDeviceStatus = [[INDeviceStatus alloc]initWithDeviceMotion:deviceMotion];
    //    newDeviceStatus.timeTag = timeCounter;
    newDeviceStatus.timeTag = timerCount;
//    [timeWindow setTimeCounter:timerCount * delta_T];
    
//    [newDeviceStatus checkIsStill];//:a_variance];
//    [newDeviceStatus updateWithVn:OldVn];
//
//    latestINLocation = [newDeviceStatus getNewLocation:latestINLocation];
//    
//    OldVn = newDeviceStatus.Vn;
    CLLocation *currentLocation = [locationManager location];
    vec_3 gpsSpeed = [INDeviceStatus getSpeedVectorBetweenLocation1:formerLocation andLocation2:currentLocation];
//    formerLocation = currentLocation;
//    vec_3 deltaSpeed;
//    deltaSpeed.v1 = OldVn.v1 - gpsSpeed.v1;
//    deltaSpeed.v2 = OldVn.v2 - gpsSpeed.v2;
//
//    if (!newDeviceStatus.isStill) {
//        [kalmanFilter calculateKwithF:newDeviceStatus.an deltaCoor:deltaSpeed andVe:OldVn.v1];
//        
//        //        NSLog(@"V:%f, %f, %f\nDist:%f, %f", [kalmanFilter.X_k getMatrixValueAtRow:0 andColumn:0],
//        //              [kalmanFilter.X_k getMatrixValueAtRow:1 andColumn:0],
//        //              [kalmanFilter.X_k getMatrixValueAtRow:2 andColumn:0],
//        //              [kalmanFilter.X_k getMatrixValueAtRow:6 andColumn:0],
//        //              [kalmanFilter.X_k getMatrixValueAtRow:7 andColumn:0]);
//        OldVn.v1 -= [kalmanFilter.X_k getMatrixValueAtRow:0 andColumn:0];
//        OldVn.v2 -= [kalmanFilter.X_k getMatrixValueAtRow:2 andColumn:0];
//        //        oldLocation.latitude += [kalmanFilter.X_k getMatrixValueAtRow:6 andColumn:0];
//        //        oldLocation.longitude += [kalmanFilter.X_k getMatrixValueAtRow:7 andColumn:0];
//        
////        //draw route onto the mapview
////        if (((NSInteger)(timerCount * delta_T)) % 3 == 0){
////            [self addNewLocationAndDraw];
////            if (routePoints.count>1){
////                CLLocation *loc1 = [routePoints objectAtIndex:routePoints.count-2];
////                CLLocation *loc2 = [routePoints objectAtIndex:routePoints.count-1];
////                self.move += [loc1 getDistanceFrom:loc2];
////            }
////        }
//    }
//    
//    //update labels
//    //        timeCounter ++;
//    //        [timeWindow setTimeCounter:timeCounter * delta_T];
//    //        xLabel.text = [NSString stringWithFormat:@"t: %.0f s", timeCounter*delta_T];
//    
//    inDistance.v1 += newDeviceStatus.Dist.v1;// + [kalmanFilter.X_k getMatrixValueAtRow:6 andColumn:0];
//    inDistance.v2 += newDeviceStatus.Dist.v2;// + [kalmanFilter.X_k getMatrixValueAtRow:7 andColumn:0];
//    inDistance.v3 += newDeviceStatus.Dist.v3;
//    
    //step counting
    [stepCounting pushNewLAcc:[INMatrix modOfVec_3:newDeviceStatus.an] GAcc:newDeviceStatus.an.v3 speed:[INMatrix modOfVec_3:gpsSpeed]];
    self.stepLabel.text = [NSString stringWithFormat:@"%d", stepCounting.counter];
    self.avgTimePerStep.text = [NSString stringWithFormat:@"%.2f", ((double)timerCount*TIMER_INTERVAL)/((double)stepCounting.counter)];
    self.avgDisPerStep.text = [NSString stringWithFormat:@"%.2f", distance/((double)stepCounting.counter)];
}

- (void)timerDot{
    doCollect = YES;
    
    timerCount++;
    
    // currently, only do running status judgement here.
    [self inertiaNavi];
    
    double time = timerCount * TIMER_INTERVAL;
    NSInteger intTime = (NSInteger)time;
    if (time - intTime < 0.001){ //1 second
        //    if (time % 3 == 0){
        [self pushPoint];
        distanceLabel.text = [NSString stringWithFormat:@"%.0lf m", distance];
        speedLabel.text = [NSString stringWithFormat:@"%.2f m/s", (float)distance/time*3.6];
        //    }
    }

    timeLabel.text = [RORUtils transSecondToStandardFormat:time];
}

- (void)pushPoint{
    CLLocation *currentLocation = self.latestUserLocation;
    if (formerLocation != currentLocation){
        distance += [self.formerLocation getDistanceFrom:currentLocation];
        self.formerLocation = currentLocation;
        [routePoints addObject:currentLocation];
        [self drawLineWithLocationArray:routePoints];
    }
}

- (IBAction)endButtonAction:(id)sender {
    [self stopUpdates];
    
    if (self.endTime == nil)
        self.endTime = [NSDate date];
    [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
    
    [locationManager stopUpdatingLocation];
    [repeatingTimer invalidate];
    [startButton setEnabled:NO];
    self.repeatingTimer = nil;
    
    [self saveRunInfo];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];    // 通过storyboard id拿到目标控制器的对象
    UIViewController *viewController =  [storyboard instantiateViewControllerWithIdentifier:@"RORRunningHistoryViewController"];
    [viewController viewDidLoad];
    
    [self performSegueWithIdentifier:@"ResultSegue" sender:self];
}

- (IBAction)setUserCentered:(id)sender {
    [self centerMap];
}

- (void)saveRunInfo{
    NSError *error = nil;
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    User_Running_History *runHistory = [NSEntityDescription insertNewObjectForEntityForName:@"User_Running_History" inManagedObjectContext:context];
    runHistory.distance = [[NSNumber alloc] initWithInteger:distance];
    runHistory.duration = [[NSNumber alloc] initWithInteger:timerCount];
    runHistory.missionRoute = [RORDBCommon getStringFromRoutePoints:routePoints];
    runHistory.missionDate = [NSDate date];
    runHistory.missionEndTime = self.endTime;
    runHistory.missionStartTime = self.startTime;
    runHistory.userId = nil;
    record = runHistory;
    if (![context save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
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
    
    if (self.routeLine != nil){
        [mapView removeOverlay:self.routeLine];
        self.routeLine = nil;
    }
    int pointCount = [locationArray count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locationArray objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
    }
    
    routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    //    [mapView setVisibleMapRect:[routeLine boundingMapRect]];
    [mapView addOverlay:routeLine];
    free(coordinateArray);
    coordinateArray = NULL;
}

- (void) centerMap{
    [mapView setCenterCoordinate:self.latestUserLocation.coordinate animated:YES];
    CLLocation *cl = [mapView userLocation].location;
    //    [self drawTestLine];
}

- (void)drawTestLine
{
    //    CLLocation *location0 = [[CLLocation alloc] initWithLatitude:31.014008 longitude:121.427551];
    ////
    ////    RORMapAnnotation *mapAnno = [[RORMapAnnotation alloc]initWithCoordinate:location0.coordinate];
    ////    mapAnno.title = @"cyberace";
    ////    mapAnno.headImage = nil;
    ////    mapAnno.subtitle = @"snail";
    ////    [mapView addAnnotation:mapAnno];
    //
    //    //31.014008,121.427551
    //    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:31.014308 longitude:121.427851];
    //    NSArray *array = [NSArray arrayWithObjects:location0,location1, nil];
    //    [self drawLineWithLocationArray:array];
}

#pragma mark - MKMapViewDelegate

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKOverlayView* overlayView = nil;
    
    if(overlay == self.routeLine)
    {
        //if we have not yet created an overlay view for this overlay, create it now.
        //        if(nil == self.routeLineView)
        //        {
        self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
        self.routeLineView.fillColor = [UIColor redColor];
        self.routeLineView.strokeColor = [UIColor redColor];
        self.routeLineView.lineWidth = 8;
        //        }
        
        overlayView = self.routeLineView;
        
    }
    
    return overlayView;
    
}

//#pragma mark Map View Delegate Methods
//- (MKAnnotationView *) mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>) annotation {
//
////    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN_ANNOTATION"];
////    if(annotationView == nil) {
////        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
////                                                          reuseIdentifier:@"PIN_ANNOTATION"];
////    }
////    annotationView.canShowCallout = YES;
////    annotationView.pinColor = MKPinAnnotationColorRed;
////    annotationView.animatesDrop = YES;
////    annotationView.highlighted = YES;
////    annotationView.draggable = YES;
////    return annotationView;
//    if ([annotation isKindOfClass:[MKUserLocation class]])
//        return nil;
//    // 处理我们自定义的Annotation
//    if ([annotation isKindOfClass:[RORMapAnnotation class]]) {
//        RORMapAnnotation *travellerAnnotation = (RORMapAnnotation *)annotation;
////        static NSString* travellerAnnotationIdentifier = @"TravellerAnnotationIdentifier";
//        static NSString *identifier = @"currentLocation";
////        SVPulsingAnnotationView *pulsingView = (SVPulsingAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
//
//        MKPinAnnotationView* pulsingView = (MKPinAnnotationView *)
//        [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
//        if (!pulsingView)
//        {
//            // if an existing pin view was not available, create one
//            pulsingView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
////            MKAnnotationView* customPinView = [[MKAnnotationView alloc]
////                                                initWithAnnotation:annotation reuseIdentifier:identifier];
//            //加展开按钮
////            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
////            [rightButton addTarget:self
////                            action:@selector(showDetails:)
////                  forControlEvents:UIControlEventTouchUpInside];
////            pulsingView.rightCalloutAccessoryView = rightButton;
////
//            UIImage *image = [UIImage imageNamed:@"smail_annotation.png"];
//            pulsingView.image = image;  //将图钉变成笑脸。
//            pulsingView.canShowCallout = YES;
////
////            UIImageView *headImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:travellerAnnotation.headImage]];
////            pulsingView.leftCalloutAccessoryView = headImage; //设置最左边的头像
//            
//            return pulsingView;
//        }
//        else
//        {
//            pulsingView.annotation = annotation;
//        }
//        return pulsingView;
//    }
//    return nil;
//}

@end
