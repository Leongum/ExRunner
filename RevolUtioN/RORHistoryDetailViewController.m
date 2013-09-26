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

@synthesize mapView, routeLine, routeLineView ,routePoints;
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
//    NSLog(@"%@", record);
    
    
    distanceLabel.text = [RORUtils outputDistance:record.distance.doubleValue];
    speedLabel.text = [RORUserUtils formatedSpeed:record.avgSpeed.doubleValue];
    durationLabel.text = [RORUtils transSecondToStandardFormat:record.duration.integerValue];
    energyLabel.text = [NSString stringWithFormat:@"%.1f kca", record.spendCarlorie.doubleValue];
    if (record.missionTypeId.integerValue == Challenge)
        scoreLabel.text = [NSString stringWithFormat:@"%@", record.grade];
    else
        scoreLabel.text = [NSString stringWithFormat:@"%d", record.experience.integerValue];

    NSDateFormatter *formattter = [[NSDateFormatter alloc] init];
    [formattter setDateFormat:@"yyyy-MM-dd"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@", [formattter stringFromDate:record.missionDate]];
    
//    bonusLabel.text = [NSString stringWithFormat:@"%@", record.scores];
//    experienceLabel.text = [NSString stringWithFormat:@"%@" , record.experience];
    
    self.routePoints = (NSMutableArray *)[RORDBCommon getRoutePointsFromString:record.missionRoute];
    
    [self drawRouteOntoMap];
    
    [RORUtils setFontFamily:CHN_PRINT_FONT forView:self.labelContainerView andSubViews:YES];
    [RORUtils setFontFamily:ENG_PRINT_FONT forView:self.dataContainerView andSubViews:YES];
    [RORUtils setFontFamily:ENG_PRINT_FONT forView:self.dateLabel andSubViews:YES];
    [RORUtils setFontFamily:CHN_PRINT_FONT forView:self.coverView andSubViews:YES];

//    [self.navigationItem.backBarButtonItem setAction:@selector(backToMain:)];
//    [delegate viewDidLoad];
}


-(void)drawRouteOntoMap{
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
    [self drawLineWithLocationArray:improvedRoute];
    [self drawLineWithLocationArray:routePoints];
    //    NSLog(@"%@", [routePoints description]);
    //    [self center_map];
    
    //    [mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
}

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
    [self setRecord:nil];
    [self setDelegate:nil];
    [self setCoverView:nil];
    [self setLabelContainerView:nil];
    [self setDataContainerView:nil];
    [self setDateLabel:nil];
    [self setMapView:nil];
    [self setRouteLine:nil];
    [self setRoutePoints:nil];
    [super viewDidUnload];
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
    
    if ([destination respondsToSelector:@selector(setRecord:)]){
        [destination setValue:record forKey:@"record"];
    }
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
    
    CGRect contentRectToCrop = CGRectMake(0, 80, image.size.width, image.size.height - 80);
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
    img = [self captureScreen];
    [Animations fadeIn:coverView andAnimationDuration:0.3 toAlpha:1 andWait:NO];
    [Animations fadeOut:self.backButton andAnimationDuration:0.3 fromAlpha:1 andWait:NO];
}

- (IBAction)hideCover:(id)sender {
    [Animations fadeOut:coverView andAnimationDuration:0.3 fromAlpha:1 andWait:NO];
    [Animations fadeIn:self.backButton andAnimationDuration:0.3 toAlpha:1 andWait:NO];
}



#pragma - map operation

- (void)center_map{
    MKCoordinateRegion region;
    CLLocationDegrees maxLat = -90;
    CLLocationDegrees maxLon = -180;
    CLLocationDegrees minLat = 90;
    CLLocationDegrees minLon = 180;
    
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
    region.center.latitude = (maxLat + minLat)/2;
    region.center.longitude = (maxLon + minLon)/2;
    region.span.latitudeDelta = maxLat - minLat ;
    region.span.longitudeDelta = maxLon - minLon;
    
    [mapView setRegion:region animated:YES];
}

- (void)drawLineWithLocationArray:(NSArray *)locationArray
{
    //    [self updateLocation];
    
    //    if (self.routeLine != nil){
    ////        [self.mapView removeOverlays:[self.mapView overlays]];
    //        [mapView removeOverlay:self.routeLine];
    //        self.routeLine = nil;
    //    }
    int pointCount = [locationArray count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locationArray objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
        
        
    }
    
    if (locationArray == routePoints)
        routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    else
        self.routeLineShadow = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    
    MKMapRect rect = [routeLine boundingMapRect];
    [mapView setVisibleMapRect:MKMapRectMake(rect.origin.x-1000, rect.origin.y-1000, rect.size.width+2000, rect.size.height+2000)];
    
    if (locationArray == routePoints)
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


@end
