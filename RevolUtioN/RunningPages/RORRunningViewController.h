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
#import "RORRunningBaseViewController.h"
#import "RORNavigationButton.h"
#import "TBCycleView.h"
#import "ROREndCircleView.h"

@interface RORRunningViewController : RORRunningBaseViewController<MKMapViewDelegate> {
    BOOL MKwasFound;
    User_Running_History *runHistory;
    NSInteger statusBarPreviousStatus;
    BOOL navigationBarHiddenPreviousStatus;
    float labelDistanceMoveOffset, labelDistanceTagMoveOffsetX, labelDistanceTagMoveOffsetY, labelTimeMoveOffset, labelTimeTagMoveOffsetX, labelTimeTagMoveOffsetY;
    float btnStartMoveOffset;
    BOOL isSoundOn;
}

@property (weak, nonatomic) IBOutlet UIButton *btnStart;
@property (strong, nonatomic) IBOutlet UIView *btnEndContainer;
@property (strong, nonatomic) IBOutlet ROREndCircleView *btnEnd;
@property (strong, nonatomic) IBOutlet RORNormalButton *btnWarmUp;
@property (strong, nonatomic) IBOutlet UIView *viewMapContainer;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *labelDistance;
@property (strong, nonatomic) IBOutlet UILabel *labelDistanceTag;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (strong, nonatomic) IBOutlet UILabel *labelTimeTag;
@property (weak, nonatomic) IBOutlet UILabel *labelSpeed;
@property (strong, nonatomic) IBOutlet UILabel *labelCalorie;
@property (strong, nonatomic) IBOutlet RORNavigationButton *btnSave;
@property (strong, nonatomic) IBOutlet UIView *dataContainer;
@property (strong, nonatomic) IBOutlet UIView *fadeContainer;
@property (strong, nonatomic) IBOutlet UIButton *btnCenterMap;
@property (strong, nonatomic) IBOutlet UIButton *btnShowMap;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UIButton *btnSound;


@property (strong, nonatomic) IBOutlet UILabel *labelDistanceTagTarget;
@property (strong, nonatomic) IBOutlet UILabel *labelDistanceTarget;
@property (strong, nonatomic) IBOutlet UILabel *labelTimeTarget;
@property (strong, nonatomic) IBOutlet UILabel *labelTimeTagTarget;
@property (strong, nonatomic) IBOutlet RORNormalButton *btnStartTarget;



@property (nonatomic) vec_3 inDistance;

@property (nonatomic) NSInteger timerCount;

@property (retain, nonatomic) MKPolylineView *viewRouteLine;
@property (retain, nonatomic) MKPolylineView *viewRouteLineShadow;
@property (strong, nonatomic) MKPolyline *lineRouteLineShadow;

@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) User_Running_History* record;

@property (nonatomic) BOOL doCollect;

@property (weak, nonatomic) IBOutlet UIControl *viewCover;

//@property (strong, nonatomic) Mission *thisMission;

- (IBAction)btnStartAction:(id)sender;
- (IBAction)btnEndAction:(id)sender;

- (IBAction)btnCoverInside:(id)sender;
- (IBAction)btnSaveRun:(id)sender;
- (IBAction)btnDeleteRunHistory:(id)sender;
- (void)saveRunInfo;
-(void)creatRunningHistory;

@end
