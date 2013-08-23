//
//  RORFirstViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-4-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORLoginViewController.h"
#import "RORSettings.h"
#import "RORThirdPartyService.h"
#import "RORAppDelegate.h"
#import "RORPages.h"
#import "RORUtils.h"
#import "Animations.h"
#import "User_Base.h"

@interface RORFirstViewController : UIViewController

@property (strong,nonatomic)NSManagedObjectContext *context;
@property (copy, nonatomic) NSString *userName;
@property (nonatomic) NSNumber *userId;
@property (weak, nonatomic) IBOutlet UIView *weatherSubView;
@property (weak, nonatomic) IBOutlet UIButton *weatherInfoButtonView;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (strong, nonatomic) IBOutlet UIButton *runButton;
@property (strong, nonatomic) IBOutlet UIScrollView *challenge;
@property (strong, nonatomic) IBOutlet UIImageView *testView;


@property (weak, nonatomic) IBOutlet UILabel *lbTemperature;
@property (weak, nonatomic) IBOutlet UILabel *lbWind;

- (IBAction)weatherInfoAction:(id)sender;
- (IBAction)normalRunAction:(id)sender;
- (IBAction)challengeRunAction:(id)sender;

@end
