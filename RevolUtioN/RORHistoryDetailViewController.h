//
//  RORHistoryDetailViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-6-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "User_Running_History.h"
#import "RORViewController.h"

@interface RORHistoryDetailViewController : RORViewController<CLLocationManagerDelegate> {
    BOOL wasFound;
    CLLocationManager* locationManager;
}
@property (weak, nonatomic) UIViewController *delegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButtonItem;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *energyLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *experienceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bonusLabel;
@property (strong, nonatomic) User_Running_History *record;

- (IBAction)backAction:(id)sender;

//@property (strong, nonatomic) NSNumber *distance;
//@property (strong, nonatomic) NSNumber *speed;
//@property (strong,nonatomic) NSNumber * duration;
//@property (strong,nonatomic) NSNumber * energy;
//@property (strong,nonatomic) NSNumber * weather;
//@property (strong,nonatomic) NSNumber * score;

@end
