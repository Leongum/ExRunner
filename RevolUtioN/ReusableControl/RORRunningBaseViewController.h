//
//  RORRunningBaseViewController.h
//  RevolUtioN
//
//  Created by Bjorn on 13-9-11.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORMapPoint.h"
#import "User_Running_History.h"
#import "RORAppDelegate.h"
#import "RORMapAnnotation.h"
#import "RORUserUtils.h"
#import "RORDBCommon.h"
#import "RORMacro.h"
#import "RORMissionServices.h"
#import "RORRunHistoryServices.h"
#import "RORUserServices.h"
#import "RORNetWorkUtils.h"
#import "INTimeWindow.h"
#import "INKalmanFilter.h"
#import "INStepCounting.h"
#import "RORViewController.h"
#import "Mission.h"
#import "RORCountDownCoverView.h"


#define TIMER_INTERVAL delta_T
#define MIN_PUSHPOINT_DISTANCE 1

@interface RORRunningBaseViewController : RORViewController<CLLocationManagerDelegate>{
    BOOL wasFound;
    BOOL isNetworkOK;
    double duration; // seconds
    double distance;
    double timeFromLastLocation;
    vec_3 currentSpeed;
    CLLocationManager *locationManager;
    CMMotionManager *motionManager;
    CLLocationCoordinate2D offset;
    CLLocation *formerLocation;
    CLLocation *latestUserLocation;
    vec_3 OldVn;
    INStepCounting *stepCounting;
    
    RORCountDownCoverView *countDownView;
    RORPlaySound *sound;
    RORPlaySound *lastHundred;
    RORPlaySound *lastKilo;
    BOOL lastHundredPlayed;
    BOOL lastKiloPlayed;
    
    CLLocation *formerCenterMapLocation;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) CMMotionManager *motionManager;

//@property (strong, nonatomic) CLLocation *initialLocation;

//@property (strong, nonatomic) CLLocation *latestUserLocation;
//@property (nonatomic) CLLocationCoordinate2D latestINLocation;
@property (strong, nonatomic) INKalmanFilter *kalmanFilter;
//@property (strong, nonatomic) INStepCounting *stepCounting;
//@property (nonatomic) vec_3 inDistance;
//@property (nonatomic) NSInteger timerCount;
//@property (assign) NSTimer *repeatingTimer;
//@property (nonatomic) BOOL isStarted;

//@property (strong, nonatomic) NSDate *startTime;
//@property (strong, nonatomic) NSDate *endTime;
//@property (strong, nonatomic) User_Running_History* record;

//@property (nonatomic) BOOL doCollect;
//
//@property (strong, nonatomic) Mission *runMission;

- (void)initOffset:(MKUserLocation *)userLocation;
-(CLLocation *)getNewRealLocation;
-(NSNumber *)calculateCalorie;
- (void)stopUpdates;
- (void)inertiaNavi;
- (void)initNavi;
- (void)startDeviceMotion;
-(NSNumber *)isValidRun:(NSInteger)steps;

@end
