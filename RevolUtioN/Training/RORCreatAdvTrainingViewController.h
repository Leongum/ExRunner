//
//  RORCreatAdvTrainingViewController.h
//  Cyberace
//
//  Created by Bjorn on 13-11-8.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "RORTrainingPickerView.h"
#import "RORPlanService.h"

@interface RORCreatAdvTrainingViewController : RORViewController<PickerCoverViewDelegate>{
    id responderTextField;

    double distance, lowSpeed, highSpeed;
    int frequency, duration, durationType;
    UIPickerView *picker;
    int trainingType;
    
    NSMutableArray *contentList;
}

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet RORTrainingPickerView *coverView;

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;

@property (strong, nonatomic) IBOutlet UIButton *frequencyLabel;
@property (strong, nonatomic) IBOutlet UIButton *durationLabel;
@property (strong, nonatomic) IBOutlet UIButton *lowSpeedLabel;
@property (strong, nonatomic) IBOutlet UIButton *highSpeedLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *trainingTypeSegment;

@property (strong, nonatomic) IBOutlet UIButton *add2ListButton;


-(Plan *)createNewAdvancedPlan;

@end
