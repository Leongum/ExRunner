//
//  RORMapViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-5.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORMapViewController.h"
#import "RORMapAnnotation.h"
#import <Foundation/Foundation.h>

@interface RORMapViewController ()

@end

@implementation RORMapViewController
@synthesize mapView, routeLine, routeLineView ,routePoints;

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

- (void)viewDidUnload{
    [self setMapView:nil];
    [self setRouteLine:nil];
    [self setRoutePoints:nil];
//    [locationManager stopUpdatingLocation];
    [super viewDidUnload];
}


//center the route line
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)update {
//    
//    locmanager = [[CLLocationManager alloc] init];
//    [locmanager setDelegate:self];
////    [locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
////    
////    [locmanager startUpdatingLocation];
//}

//CLLocationManager* locmanager;
//-(void)awakeFromNib {
////    [self update];
//}

//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    if (wasFound) return;
//    wasFound = YES;
//}

//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    
//}

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
