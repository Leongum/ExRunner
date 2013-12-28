//
//  RORCreatSimpleTrainingViewController.h
//  Cyberace
//
//  Created by Bjorn on 13-11-8.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "RORPlanService.h"
#import "RORTrainingPickerView.h"
#import "RORSegmentControl.h"

@interface RORCreatSimpleTrainingViewController : RORViewController<PickerCoverViewDelegate>{
    id responderTextField;
    double distance, highSpeed, lowSpeed;
    int total, frequency, duration, trainingType;
    UIPickerView *picker;
}

@property (strong, nonatomic) IBOutlet UIView *contentView;
//@property (strong, nonatomic) IBOutlet UIButton *distanceTextField;
@property (strong, nonatomic) IBOutlet UIButton *totalTextField;
@property (strong, nonatomic) IBOutlet UIButton *frequencyTextField;
@property (strong, nonatomic) IBOutlet UIButton *durationTextField;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UIButton *highSpeedField;
@property (strong, nonatomic) IBOutlet UIButton *lowSpeedField;

@property (strong, nonatomic) IBOutlet RORTrainingPickerView *coverView;

@property (strong, nonatomic) IBOutlet RORSegmentControl *trainingTypeSegment;
@property (strong, nonatomic) IBOutlet UIImageView *trainingTypeSegmentBg;

-(Plan *)createNewSimplePlan;
@end
