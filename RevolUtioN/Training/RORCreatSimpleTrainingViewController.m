//
//  RORCreatSimpleTrainingViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-11-8.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORCreatSimpleTrainingViewController.h"

@interface RORCreatSimpleTrainingViewController ()

@end

@implementation RORCreatSimpleTrainingViewController
@synthesize totalTextField, frequencyTextField, durationTextField, trainingTypeSegment, lowSpeedField, highSpeedField;

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
    
    self.backButton.alpha = 0;
    self.coverView.delegate = self;
    self.coverView.alpha = 0;
    
    [self.totalTextField addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.frequencyTextField addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.durationTextField addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.lowSpeedField addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.highSpeedField addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
    
    picker = self.coverView.picker;
}

-(void)initData{
    distance = 3;
    highSpeed = 300;
    lowSpeed = 540;
    total = 5;
    frequency = 3;
    duration = 1800;
    trainingType = 0;
}

-(void)initControls{
//    [distanceTextField setTitle:[NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:distance]] forState:UIControlStateNormal];
    
    if (trainingType == 0)
        [durationTextField setTitle:[NSString stringWithFormat:@"定距：%@km", [NSNumber numberWithDouble:distance]] forState:UIControlStateNormal];
    else
        [durationTextField setTitle:[NSString stringWithFormat:@"计时：%@",[RORUtils transSecondToStandardFormat:duration]] forState:UIControlStateNormal];
    [frequencyTextField setTitle:[NSString stringWithFormat:@"周期：%d天", frequency] forState:UIControlStateNormal] ;
    [lowSpeedField setTitle:[NSString stringWithFormat:@"低速：%@",[RORUtils transSecondToStandardFormat:lowSpeed]] forState:UIControlStateNormal];
    [highSpeedField setTitle:[NSString stringWithFormat:@"高速：%@",[RORUtils transSecondToStandardFormat:highSpeed]] forState:UIControlStateNormal];
    [totalTextField setTitle:[NSString stringWithFormat:@"共%d次", total] forState:UIControlStateNormal];
    [self.trainingTypeSegment setSelectedSegmentIndex:trainingType];
}

-(void)viewWillAppear:(BOOL)animated{
    self.contentView.frame = self.view.frame;
    [self initData];
    [self initControls];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)initPicker:(id)sender{
    
    responderTextField = sender;
    
    if (responderTextField == totalTextField){
        [self.coverView showMiddleTitle:@"一共几次"];
    }
    if (responderTextField == durationTextField){
        if (trainingTypeSegment.selectedSegmentIndex == 0)
            [self.coverView showMiddleTitle:@"km"];
        else
            [self.coverView showBothSideTitle:@"小时" t2:@"分钟"];
    }
    if (responderTextField == frequencyTextField){
        [self.coverView showMiddleTitle:@"几天内完成"];
    }
    if (responderTextField == lowSpeedField){
        [self.coverView showMiddleTitle:@"最低配速"];
    }
    if (responderTextField == highSpeedField){
        [self.coverView showMiddleTitle:@"最高配速"];
    }
    
    [picker reloadAllComponents];
    [self scrollToCurrentValue];
}

-(void)scrollToCurrentValue{
    if (responderTextField == durationTextField){
        if (trainingTypeSegment.selectedSegmentIndex == 0){
            [picker selectRow:(int)distance inComponent:0 animated:YES];
            if (distance-(int)distance < 0.01)
                [picker selectRow:0 inComponent:1 animated:YES];
            else if (distance - (int)distance <0.4)
                [picker selectRow:2 inComponent:1 animated:YES];
            else
                [picker selectRow:1 inComponent:1 animated:YES];
        }
        else {
            [picker selectRow:(int)duration/3600 inComponent:0 animated:YES];
            [picker selectRow:((int)duration%3600)/60 inComponent:1 animated:YES];
        }
    }
    if (responderTextField == totalTextField){
        [picker selectRow:total-1 inComponent:0 animated:YES];
    }
    if (responderTextField == frequencyTextField){
        [picker selectRow:frequency-1 inComponent:0 animated:YES];
    }
    if (responderTextField == lowSpeedField){
        [picker selectRow:(int)lowSpeed/60 -2 inComponent:0 animated:YES];
        [picker selectRow:(int)lowSpeed%60 inComponent:1 animated:YES];
    }
    if (responderTextField == highSpeedField){
        [picker selectRow:(int)highSpeed/60 -2 inComponent:0 animated:YES];
        [picker selectRow:(int)highSpeed%60 inComponent:1 animated:YES];
    }
}

-(IBAction)showPicker:(id)sender{
    [self.titleTextField resignFirstResponder];
    [self initPicker:sender];
    self.coverView.alpha = 1;
}

-(BOOL) checkInput{
    if (self.titleTextField.text.length<=0){
        [self sendAlart:@"请输入训练名"];
        return NO;
    }
    
    return YES;
}

-(Plan *)createNewSimplePlan{
    if (![self checkInput]){
        return nil;
    }
    
    Plan *newPlan = [Plan intiUnassociateEntity];
    newPlan.planName = self.titleTextField.text;
    newPlan.totalMissions = [NSNumber numberWithInt:total];
    newPlan.planType = [NSNumber numberWithInt:PlanTypeEasy];
    newPlan.durationType = [NSNumber numberWithInt:DurationTypeDay];
    newPlan.lastUpdateTime = [NSDate date];
//    if (durationType == DurationTypeWeek){
//        newPlan.cycleTime = [NSNumber numberWithInt:frequency];
//        newPlan.duration = [NSNumber numberWithInt:1];
//    } else if (durationType == DurationTypeDay){
    newPlan.duration = [NSNumber numberWithInt:frequency];
    newPlan.cycleTime = [NSNumber numberWithInt:1];
//    }
    Mission *mission = [Mission intiUnassociateEntity];
    if (trainingType == 0){
        mission.missionDistance = [NSNumber numberWithInt:distance*1000];
        mission.missionTime = [NSNumber numberWithInt:0];
    } else {
        mission.missionDistance = [NSNumber numberWithInt:0];
        mission.missionTime = [NSNumber numberWithInt:duration];
    }
    mission.missionName = [NSString stringWithFormat:@"%@1", newPlan.planName];
    mission.missionTypeId = [NSNumber numberWithInt:SimpleTask];
    mission.suggestionMinSpeed = [RORUserUtils timePerKM2kmPerHour:lowSpeed];
    mission.suggestionMaxSpeed = [RORUserUtils timePerKM2kmPerHour:highSpeed];
    mission.lastUpdateTime = newPlan.lastUpdateTime;
    mission.sequence = [NSNumber numberWithInt:0];
    mission.cycleTime = newPlan.duration;
    
    newPlan.missionList = [[NSMutableArray alloc]initWithObjects:mission, nil];
    
    return newPlan;
}

- (IBAction)hideCover:(id)sender {
    if (responderTextField == durationTextField){
        if ( trainingTypeSegment.selectedSegmentIndex == 0){
            distance = [picker selectedRowInComponent:0];
            switch ([picker selectedRowInComponent:1]) {
                case 0:
                    break;
                case 1:
                    distance += 0.5;
                    break;
                case 2:
                    distance += .195;
                    break;
                default:
                    break;
            };
            [durationTextField setTitle:[NSString stringWithFormat:@"定距：%@km", [NSNumber numberWithDouble:distance]] forState:UIControlStateNormal];
        }
        else{
            duration = [picker selectedRowInComponent:0]*3600 +
            [picker selectedRowInComponent:1]*60;
            [durationTextField setTitle:[NSString stringWithFormat:@"计时：%@",[RORUtils transSecondToStandardFormat:duration]] forState:UIControlStateNormal];
        }
    }

    if (responderTextField == frequencyTextField){
        frequency = [picker selectedRowInComponent:0]+1;
        [frequencyTextField setTitle:[NSString stringWithFormat:@"周期：%d天", frequency] forState:UIControlStateNormal] ;
    }
    if (responderTextField == totalTextField){
        total = [picker selectedRowInComponent:0]+1;
        [totalTextField setTitle:[NSString stringWithFormat:@"共%d次", total] forState:UIControlStateNormal];
    }
    
    if (responderTextField == self.highSpeedField){
        highSpeed = ([picker selectedRowInComponent:0]+2)*60 + [picker selectedRowInComponent:1];
        [highSpeedField setTitle:[NSString stringWithFormat:@"高速：%@",[RORUtils transSecondToStandardFormat:highSpeed]] forState:UIControlStateNormal];
    }
    if (responderTextField == self.lowSpeedField){
        lowSpeed = ([picker selectedRowInComponent:0]+2)*60 + [picker selectedRowInComponent:1];
        [lowSpeedField setTitle:[NSString stringWithFormat:@"低速：%@",[RORUtils transSecondToStandardFormat:lowSpeed]] forState:UIControlStateNormal];
    }
}

- (IBAction)hideKeyboard:(id)sender {
    [self.titleTextField resignFirstResponder];
}

- (IBAction)trainingTypeChangedAction:(id)sender {
    trainingType = self.trainingTypeSegment.selectedSegmentIndex;
    if (trainingType == 0){
        [self.trainingTypeSegmentBg setImage:[UIImage imageNamed:@"trainingTypeSeg_bg.png"]];
    } else {
        [self.trainingTypeSegmentBg setImage:[UIImage imageNamed:@"trainingTypeSeg_bg1.png"]];
    }
    [self initControls];
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    if (responderTextField == durationTextField || responderTextField == self.highSpeedField || responderTextField == self.lowSpeedField)
        return 2;
    return 1;
}

- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (responderTextField == durationTextField){
        if ( trainingTypeSegment.selectedSegmentIndex == 0){
            switch (component) {
                case 0:
                    return 43;
                case 1:
                    return 3;
                default:
                    break;
            };
        } else {
            switch (component) {
                case 0:
                    return 6;
                case 1:
                    return 60;
                default:
                    break;
            }
        }
    }
    if (responderTextField == frequencyTextField)
        return 7;
    if (responderTextField == totalTextField)
        return 50;
    if (responderTextField == self.highSpeedField || responderTextField == self.lowSpeedField){
        switch (component) {
            case 0:
                return 11;
            case 1:
                return 60;
            default:
                break;
        }
    }
        
    return 0;
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (responderTextField == frequencyTextField || responderTextField == totalTextField)
        return [NSString stringWithFormat:@"%d", row+1];
    if (responderTextField == durationTextField){
        if ( trainingTypeSegment.selectedSegmentIndex == 0){
            if (component == 1){
                switch (row) {
                    case 0:
                        return @".0";
                    case 1:
                        return @".5";
                    case 2:
                        return @".195";
                    default:
                        break;
                }
            }
        }
    }
    if (responderTextField == self.highSpeedField || responderTextField == self.lowSpeedField){
        switch (component) {
            case 0:
                return [NSString stringWithFormat:@"%d",row+2];
            default:
                break;
        }
    }
    return [NSString stringWithFormat:@"%d",row];
    
    //    }
    return nil;
}

//- (CGFloat)pickerView:(UIPickerView*)pickerView widthForComponent:(NSInteger)component{
//    if (component<3)
//        return 80;
//    return 40;
//}


#pragma mark Training Picker Cover View Delegate
- (void) didFinishPicking{
    [self hideCover:self];
}

@end
