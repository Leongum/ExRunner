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

#define ROUTE_NORMAL 0
#define ROUTE_SHADOW 1

@interface RORHistoryDetailViewController ()
    
@end

@implementation RORHistoryDetailViewController{
    UIImage *img;
}

@synthesize mapView, routeLine, routeLineView;
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


//===============================================
//life cycle
//===============================================
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    NSLog(@"%@", record);
    
    CGRect rx = [ UIScreen mainScreen ].applicationFrame;
    if (rx.size.height < 500){
        [Animations moveUp:self.backButton andAnimationDuration:0 andWait:NO andLength:8];
        [Animations moveUp:self.shareButton andAnimationDuration:0 andWait:NO andLength:8];
    }

    distanceLabel.text = [RORUtils outputDistance:record.distance.doubleValue];
    speedLabel.text = [RORUserUtils formatedSpeed:record.avgSpeed.doubleValue];
    durationLabel.text = [RORUtils transSecondToStandardFormat:record.duration.integerValue];
    energyLabel.text = [NSString stringWithFormat:@"%.1f kca", record.spendCarlorie.doubleValue];
    if (record.missionTypeId.integerValue == Challenge){
        scoreLabel.text = [NSString stringWithFormat:@"%@", MissionGradeEnum_toString[record.missionGrade.integerValue]];
        self.levelTitleLabel.text = @"级别";
    }
    else {
        scoreLabel.text = [NSString stringWithFormat:@"%d", record.experience.integerValue];
        self.levelTitleLabel.text = @"得分";
    }
    
    if (record.missionTypeId.integerValue == SimpleTask || record.missionTypeId.integerValue==ComplexTask){
        
    }
    
    if (record.valid.integerValue<0) {
        scoreLabel.textColor = [UIColor redColor];
        if (record.valid.integerValue==-1)
            scoreLabel.text = @"NOT A RUNNING";

        if (record.valid.integerValue == -2)
            scoreLabel.text = @"BAD NETWORK";

    }
    
    NSDateFormatter *formattter = [[NSDateFormatter alloc] init];
    [formattter setDateFormat:@"yyyy-MM-dd"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@", [formattter stringFromDate:record.missionDate]];
    
//    bonusLabel.text = [NSString stringWithFormat:@"%@", record.scores];
//    experienceLabel.text = [NSString stringWithFormat:@"%@" , record.experience];
    
    routes = (NSMutableArray *)[RORDBCommon getRoutesFromString:record.missionRoute];
    CLLocation *startLoc=nil;
    CLLocation *endLoc=nil;
    for (int i=0; i<routes.count; i++) {
        NSArray *routePoints = [routes objectAtIndex:i];
        if (routePoints==nil || routePoints.count==0)
            continue;
        if (startLoc==nil){
            startLoc = [routePoints objectAtIndex:0];
            RORStartAnnotation *annotation = [[RORStartAnnotation alloc]initWithCoordinate:startLoc.coordinate];
            annotation.title = @"起点";
            [mapView addAnnotation:annotation];
        }
        endLoc = [routePoints objectAtIndex:routePoints.count-1];
        [self drawRouteOntoMap:routePoints];
    }
    ROREndAnnotation *annotation = [[ROREndAnnotation alloc]initWithCoordinate:endLoc.coordinate];
    annotation.title = @"终点";
    [mapView addAnnotation:annotation];
    
    [self center_map];
    
    [RORUtils setFontFamily:CHN_PRINT_FONT forView:self.labelContainerView andSubViews:YES];
    [RORUtils setFontFamily:ENG_PRINT_FONT forView:self.dataContainerView andSubViews:YES];
    [RORUtils setFontFamily:ENG_PRINT_FONT forView:self.dateLabel andSubViews:YES];
    [RORUtils setFontFamily:CHN_PRINT_FONT forView:self.coverView andSubViews:YES];
    [RORUtils setFontFamily:CHN_PRINT_FONT forView:self.dragLabel andSubViews:NO];
    
    [self addGestures];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    User_Running_History *best = [RORRunHistoryServices fetchBestRunHistoryByMissionId:record.missionId withUserId:[RORUserUtils getUserId]];
    if (record.missionTypeId.integerValue == Challenge && [delegate isKindOfClass:[RORRunningBaseViewController class]] && record.valid.integerValue>0)
    {
        RORChallengeCongratsCoverView *congratsCoverView = [[RORChallengeCongratsCoverView alloc]initWithFrame:self.coverView.frame andLevel:record];
        [self.view addSubview:congratsCoverView];
        [congratsCoverView show:self];
    }
    if ((record.missionTypeId.integerValue == SimpleTask || record.missionTypeId.integerValue == ComplexTask) &&  [delegate isKindOfClass:[RORRunningBaseViewController class]]){
        RORTrainingCongratsCoverView *congratsCoverView = [[RORTrainingCongratsCoverView alloc]initWithFrame:self.coverView.frame andLevel:record];
        [self.view addSubview:congratsCoverView];
        [congratsCoverView show:self];
    }
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
    [self setRecord:nil];
    [self setDelegate:nil];
    [self setCoverView:nil];
    [self setLabelContainerView:nil];
    [self setDataContainerView:nil];
    [self setDateLabel:nil];
    [self setMapView:nil];
    [self setRouteLine:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setRoutes:)]){
        [destination setValue:[RORDBCommon getRoutesFromString:record.missionRoute] forKey:@"routes"];
    }
    if ([destination respondsToSelector:@selector(setShareImage:)]){
        [destination setValue:img forKey:@"shareImage"];
    }
    
    if ([destination respondsToSelector:@selector(setRecord:)]){
        [destination setValue:record forKey:@"record"];
    }
}


//===============================================
//gestures for map cover view
//===============================================
-(void)addGestures{
    UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.mapCoverView addGestureRecognizer:t];
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.mapCoverView addGestureRecognizer:panGes];
}

-(void) singleTap:(UITapGestureRecognizer*) tap {
    if (expanded) {
        [self popView];
        expanded = 0;
    }
    else {
        [self inView];
        expanded = 1;
    }
}
    
-(void) panAction:(UIPanGestureRecognizer*) recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        self.mapView.alpha = 0;
        centerLoc = self.mapCoverView.center.x;
        //        NSLog(@"began");
    }
    else if(recognizer.state==UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:self.mapCoverView];
        [self dragView:translation.x];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
            int trans = self.mapCoverView.center.x - centerLoc;
            if (trans<0 && expanded == 0 ){
                [self inView];
                expanded = 1;
            } else if (trans>0 && expanded == 1 ){
                [self popView];
                expanded = 0;
            }
    //        self.mapView.alpha = 1;
    }
    [recognizer setTranslation:CGPointZero inView:self.mapCoverView];
}

- (void)dragView : (int)transition{
    UIView* localView = self.mapCoverView;
    int mostLeft = 23 + localView.frame.size.width/2;
    int mostRight = 285 + localView.frame.size.width/2;
    
    if (localView.center.x + transition>mostRight)
        localView.center = CGPointMake(mostRight,localView.center.y); //61.5
    else if (localView.center.x  + transition<mostLeft)
        localView.center = CGPointMake(mostLeft, localView.center.y);//25.5
    else localView.center = CGPointMake(localView.center.x + transition,
                                        localView.center.y);
}

- (void)inView{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];
    
    self.mapCoverView.center = CGPointMake(23 + self.mapCoverView.frame.size.width/2, self.mapCoverView.center.y);
    expanded = 1;
    [self.mapView setUserInteractionEnabled:NO];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

- (void)popView{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];

    self.mapCoverView.center = CGPointMake(285 + self.mapCoverView.frame.size.width/2, self.mapCoverView.center.y);
    expanded = 0;
    [self.mapView setUserInteractionEnabled:YES];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}



-(void)drawRouteOntoMap:(NSArray *)routePoints{
    if (routePoints.count == 0 || routePoints == nil)
        return;
    
    int couter = 4;
    while (couter-- > 0) {
        improvedRoute = [[NSMutableArray alloc]init];
        [improvedRoute addObject:[routePoints objectAtIndex:0]];
        for (int i=0; i<routePoints.count-1; i++){
            CLLocation *locnext = [routePoints objectAtIndex:i+1];
            CLLocation *locpre = [routePoints objectAtIndex:i];
            
            CLLocationCoordinate2D Q,R;
            Q.latitude = 0.75 * locpre.coordinate.latitude + 0.25 * locnext.coordinate.latitude;
            Q.longitude = 0.75 * locpre.coordinate.longitude + 0.25 * locnext.coordinate.longitude;
            R.latitude = 0.25 * locpre.coordinate.latitude + 0.75 * locnext.coordinate.latitude;
            R.longitude = 0.25 * locpre.coordinate.longitude + 0.75 * locnext.coordinate.longitude;
            
            [improvedRoute addObject:[[CLLocation alloc]initWithLatitude:Q.latitude longitude:Q.longitude]];
            [improvedRoute addObject:[[CLLocation alloc]initWithLatitude:R.latitude longitude:R.longitude]];
        }
        [improvedRoute addObject:[routePoints objectAtIndex:routePoints.count-1]];
        routePoints = improvedRoute;
    }
    improvedRoute = [[NSMutableArray alloc]init];
    for (int i=0; i<routePoints.count; i++){
        CLLocation *loc = [routePoints objectAtIndex:i];
        [improvedRoute addObject:[[CLLocation alloc]initWithLatitude:loc.coordinate.latitude - 0.00002 longitude:loc.coordinate.longitude]];
    }
    
    [self drawLineWithLocationArray:improvedRoute withStyle:ROUTE_SHADOW];
    [self drawLineWithLocationArray:routePoints withStyle:ROUTE_NORMAL];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backAction:(id)sender {
    if ([delegate isKindOfClass:[RORRunningBaseViewController class]]){
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else
        [self.navigationController popViewControllerAnimated:YES];
}



#pragma - Share Actions

- (UIImage *) captureScreen {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect contentRectToCrop = CGRectMake(0, 0, image.size.width, image.size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], contentRectToCrop);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
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
                                [self sendAlart:[error errorDescription]];
                            }
                        }
                    }];

}

- (IBAction)shareAction:(id)sender {
    self.backButton.alpha = 0;
    self.shareButton.alpha = 0;
    img = [self captureScreen];
    self.coverView.alpha = 1;
//    [Animations fadeIn:coverView andAnimationDuration:0.3 toAlpha:1 andWait:NO];
//    [Animations fadeOut:self.backButton andAnimationDuration:0.3 fromAlpha:1 andWait:NO];
}

- (IBAction)hideCover:(id)sender {
    self.backButton.alpha = 1;
    self.shareButton.alpha = 1;
    self.coverView.alpha = 0;
//    [Animations fadeOut:coverView andAnimationDuration:0.3 fromAlpha:1 andWait:NO];
//    [Animations fadeIn:self.backButton andAnimationDuration:0.3 toAlpha:1 andWait:NO];
}



#pragma - map operation

- (void)center_map{
    MKCoordinateRegion region;
    CLLocationDegrees maxLat = -90;
    CLLocationDegrees maxLon = -180;
    CLLocationDegrees minLat = 90;
    CLLocationDegrees minLon = 180;
    for (NSArray *routePoints in routes){
        for (int i=0; i<routePoints.count; i++){
            CLLocation *currentLocation = [routePoints objectAtIndex:i];
            if (currentLocation.coordinate.latitude > maxLat)
                maxLat = currentLocation.coordinate.latitude;
            if (currentLocation.coordinate.longitude > maxLon)
                maxLon = currentLocation.coordinate.longitude;
            if (currentLocation.coordinate.latitude < minLat)
                minLat = currentLocation.coordinate.latitude;
            if (currentLocation.coordinate.longitude < minLon)
                minLon = currentLocation.coordinate.longitude;
        }
    }
    region.center.latitude = (maxLat + minLat)/2;
    region.center.longitude = (maxLon + minLon)/2;
    region.span.latitudeDelta = maxLat - minLat + 0.003 ;
    region.span.longitudeDelta = maxLon - minLon + 0.003;
    
    [mapView setRegion:region animated:YES];
}

- (void)drawLineWithLocationArray:(NSArray *)locationArray withStyle:(NSInteger)style
{
    
    int pointCount = [locationArray count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locationArray objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
    }
    
    if (style == ROUTE_NORMAL)
        routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    else
        self.routeLineShadow = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    
    MKMapRect rect = [routeLine boundingMapRect];
    [mapView setVisibleMapRect:MKMapRectMake(rect.origin.x-1000, rect.origin.y-1000, rect.size.width+2000, rect.size.height+2000)];
    
    if (style == ROUTE_NORMAL)
        [mapView addOverlay:routeLine];
    else
        [mapView addOverlay:self.routeLineShadow];
    
    free(coordinateArray);
    coordinateArray = NULL;
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
        //        self.routeLineView.fillColor = [UIColor colorWithRed:223 green:8 blue:50 alpha:1];
        self.routeLineView.strokeColor = [UIColor colorWithRed:(46.0/255.0) green:(170.0/255.0) blue:(218.0/255.0) alpha:1];
        self.routeLineView.lineWidth = 10;
        //        }
        overlayView = self.routeLineView;
        
    } else if (overlay == self.routeLineShadow){
        self.routeLineShadowView = [[MKPolylineView alloc] initWithPolyline:self.routeLineShadow];
        //        self.routeLineView.fillColor = [UIColor colorWithRed:223 green:8 blue:50 alpha:1];
        self.routeLineShadowView.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        self.routeLineShadowView.lineWidth = 11;
        //        }
        
        overlayView = self.routeLineShadowView;
    }
    
    return overlayView;
    
}


//#pragma mark Map View Delegate Methods
- (MKAnnotationView *) mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>) annotation {

//    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN_ANNOTATION"];
//    if(annotationView == nil) {
//        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
//                                                          reuseIdentifier:@"PIN_ANNOTATION"];
//    }
//    annotationView.canShowCallout = YES;
//    annotationView.pinColor = MKPinAnnotationColorRed;
//    annotationView.animatesDrop = YES;
//    annotationView.highlighted = YES;
//    annotationView.draggable = YES;
//    return annotationView;
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    // 处理我们自定义的Annotation
    if ([annotation isKindOfClass:[RORMapAnnotation class]]) {
//        RORMapAnnotation *travellerAnnotation = (RORMapAnnotation *)annotation;
//        static NSString* travellerAnnotationIdentifier = @"TravellerAnnotationIdentifier";
        static NSString *identifier = @"currentLocation";
//        SVPulsingAnnotationView *pulsingView = (SVPulsingAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];

        MKPinAnnotationView* pulsingView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!pulsingView)
        {
            // if an existing pin view was not available, create one
            pulsingView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
//            MKAnnotationView* customPinView = [[MKAnnotationView alloc]
//                                                initWithAnnotation:annotation reuseIdentifier:identifier];
            //加展开按钮
//            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//            [rightButton addTarget:self
//                            action:@selector(showDetails:)
//                  forControlEvents:UIControlEventTouchUpInside];
//            pulsingView.rightCalloutAccessoryView = rightButton;
//
            UIImage *image;
            if ([annotation isKindOfClass:[RORStartAnnotation class]])
                image = [UIImage imageNamed:@"start_annotation.png"];
            else
                image = [UIImage imageNamed:@"end_annotation.png"];

            pulsingView.image = image;
            pulsingView.canShowCallout = YES;
//
//            UIImageView *headImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:travellerAnnotation.headImage]];
//            pulsingView.leftCalloutAccessoryView = headImage; //设置最左边的头像
            return pulsingView;
        }
        else
        {
            pulsingView.annotation = annotation;
        }
        return pulsingView;
    }
    
    return nil;
}



@end
