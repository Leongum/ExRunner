//
//  RORGetReadyViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "User_Running_History.h"
#import "INTimeWindow.h"
#import "INKalmanFilter.h"
#import "INStepCounting.h"
#import "RORViewController.h"
#import "Mission.h"

#define TIMER_INTERVAL delta_T

@interface RORRunningViewController : RORViewController<CLLocationManagerDelegate,MKMapViewDelegate> {
    BOOL wasFound;
    BOOL isNetworkOK;
    double duration; // seconds
    double timeFromLastLocation;
    vec_3 currentSpeed;
}
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) CMMotionManager *motionManager;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UIButton *expandButton;
@property (weak, nonatomic) IBOutlet UIButton *collapseButton;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgDisPerStep;
@property (weak, nonatomic) IBOutlet UILabel *avgTimePerStep;


@property (strong, nonatomic) CLLocation *initialLocation;
@property (strong, nonatomic) CLLocation *formerLocation;
@property (strong, nonatomic) CLLocation *latestUserLocation;
@property (nonatomic) CLLocationCoordinate2D latestINLocation;
@property (nonatomic) vec_3 OldVn;
@property (strong, nonatomic) INKalmanFilter *kalmanFilter;
@property (strong, nonatomic) INStepCounting *stepCounting;
@property (nonatomic) vec_3 inDistance;
@property (nonatomic) CLLocationCoordinate2D offset;
@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger timerCount;
@property (assign) NSTimer *repeatingTimer;
@property (nonatomic) BOOL isStarted;
@property (nonatomic) double distance; // meters
@property (retain, nonatomic) NSMutableArray *routePoints;
@property (retain, nonatomic) MKPolyline *routeLine;
@property (retain, nonatomic) MKPolylineView *routeLineView;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) User_Running_History* record;

@property (nonatomic) BOOL doCollect;

@property (strong, nonatomic) Mission *runMission;

- (IBAction)expandAction:(id)sender;
- (IBAction)collapseAction:(id)sender;
- (IBAction)startButtonAction:(id)sender;
- (IBAction)endButtonAction:(id)sender;
- (IBAction)setUserCentered:(id)sender;


- (IBAction)btnCoverInside:(id)sender;
@property (weak, nonatomic) IBOutlet UIControl *coverView;
- (IBAction)btnSaveRun:(id)sender;
- (IBAction)btnDeleteRunHistory:(id)sender;


@end
