//
//  RORChanllengeRunViewController.h
//  RevolUtioN
//
//  Created by Bjorn on 13-9-11.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORRunningBaseViewController.h"

#define SCALE_SMALL CGRectMake(0,0,320,155)


@interface RORChanllengeRunViewController : RORRunningBaseViewController<MKMapViewDelegate>{
    BOOL MKwasFound;
    Mission *mission;
}

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UIButton *expandButton;
@property (weak, nonatomic) IBOutlet UIButton *collapseButton;

@property (nonatomic) NSInteger timerCount;
@property (assign) NSTimer *repeatingTimer;
@property (nonatomic) BOOL isStarted;
//@property (nonatomic) double distance; // meters
@property (retain, nonatomic) NSMutableArray *routePoints;
@property (retain, nonatomic) MKPolyline *routeLine;
@property (retain, nonatomic) MKPolylineView *routeLineView;
@property (retain, nonatomic) MKPolylineView *routeLineShadowView;
@property (strong, nonatomic) MKPolyline *routeLineShadow;

@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) User_Running_History* record;

@property (nonatomic) BOOL doCollect;

@property (strong, nonatomic) Mission *runMission;
@property (weak, nonatomic) IBOutlet UIControl *coverView;
@end