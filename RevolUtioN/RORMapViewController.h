//
//  RORMapViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-5.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RORViewController.h"

@interface RORMapViewController : RORViewController<CLLocationManagerDelegate,   MKMapViewDelegate>{
//    BOOL wasFound;
//    CLLocationManager* locationManager;
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKPolyline *routeLine;
@property (retain, nonatomic) NSMutableArray *routePoints;
@property (retain, nonatomic) MKPolylineView *routeLineView;

@end
