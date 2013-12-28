//
//  RORCreatAdvTrainingViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-11-8.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORCreatAdvTrainingViewController.h"

@interface RORCreatAdvTrainingViewController ()

@end

@implementation RORCreatAdvTrainingViewController
@synthesize durationLabel, lowSpeedLabel, highSpeedLabel, frequencyLabel, trainingTypeSegment;

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
    
    [self.frequencyLabel addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.durationLabel addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.lowSpeedLabel addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.highSpeedLabel addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
    
    picker = self.coverView.picker;
    
    contentList = [[NSMutableArray alloc]init];
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

-(void)initData{
    distance = 3;
    lowSpeed = 540;
    highSpeed = 300;
    frequency = 3;
    duration = 1800;
    trainingType = 0;
}

-(void)initControls{
    if (trainingType == 0)
        [durationLabel setTitle:[NSString stringWithFormat:@"定距：%@km", [NSNumber numberWithDouble:distance]] forState:UIControlStateNormal];
    else
        [durationLabel setTitle:[NSString stringWithFormat:@"计时：%@",[RORUtils transSecondToStandardFormat:duration]] forState:UIControlStateNormal];
    [frequencyLabel setTitle:[NSString stringWithFormat:@"周期：%d天", frequency] forState:UIControlStateNormal] ;
    [self.lowSpeedLabel setTitle:[NSString stringWithFormat:@"低速：%@",[RORUtils transSecondToStandardFormat:lowSpeed]] forState:UIControlStateNormal];
    [self.highSpeedLabel setTitle:[NSString stringWithFormat:@"高速：%@",[RORUtils transSecondToStandardFormat:highSpeed]] forState:UIControlStateNormal];
    
    trainingTypeSegment = [trainingTypeSegment initWithFrame:trainingTypeSegment.frame andSegmentNumber:2];
    trainingTypeSegment.delegate = self;
    [trainingTypeSegment setSegmentTitle:@"定距" withIndex:0];
    [trainingTypeSegment setSegmentTitle:@"计时" withIndex:1];
    [trainingTypeSegment selectSegmentAtIndex:trainingType];
}

-(void)scrollToCurrentValue{
    if (responderTextField == durationLabel){
        if (trainingTypeSegment.selectionIndex == 0){
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
    if (responderTextField == frequencyLabel){
        [picker selectRow:frequency-1 inComponent:0 animated:YES];
    }
    if (responderTextField == lowSpeedLabel){
        [picker selectRow:(int)lowSpeed/60 -2 inComponent:0 animated:YES];
        [picker selectRow:(int)lowSpeed%60 inComponent:1 animated:YES];
    }
    if (responderTextField == highSpeedLabel){
        [picker selectRow:(int)highSpeed/60 -2 inComponent:0 animated:YES];
        [picker selectRow:(int)highSpeed%60 inComponent:1 animated:YES];
    }
}

-(IBAction)initPicker:(id)sender{
    responderTextField = sender;
    
    if (responderTextField == durationLabel){
        if (trainingTypeSegment.selectionIndex == 0)
            [self.coverView showMiddleTitle:@"km"];
        else
            [self.coverView showBothSideTitle:@"小时" t2:@"分钟"];
    }
    if (responderTextField == frequencyLabel){
        [self.coverView showMiddleTitle:@"几天内完成"];
    }
    if (responderTextField == lowSpeedLabel){
        [self.coverView showMiddleTitle:@"最低配速"];
    }
    if (responderTextField == highSpeedLabel){
        [self.coverView showMiddleTitle:@"最高配速"];
    }
    
    [picker reloadAllComponents];
    [self scrollToCurrentValue];
}

- (IBAction)hideCover:(id)sender {
    if (responderTextField == durationLabel){
        if ( trainingTypeSegment.selectionIndex == 0){
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
            [durationLabel setTitle:[NSString stringWithFormat:@"定距：%@", [NSNumber numberWithDouble:distance]] forState:UIControlStateNormal];
        }
        else{
            duration = [picker selectedRowInComponent:0]*3600 +
            [picker selectedRowInComponent:1]*60;
            [durationLabel setTitle:[NSString stringWithFormat:@"计时：%@",[RORUtils transSecondToStandardFormat:duration]] forState:UIControlStateNormal];
        }
    }
    if (responderTextField == frequencyLabel){
        frequency = [picker selectedRowInComponent:0]+1;
        [frequencyLabel setTitle:[NSString stringWithFormat:@"周期：%d天", frequency] forState:UIControlStateNormal] ;
    }
    if (responderTextField == lowSpeedLabel){
        lowSpeed = ([picker selectedRowInComponent:0]+2)*60 + [picker selectedRowInComponent:1];
        [self.lowSpeedLabel setTitle:[NSString stringWithFormat:@"低速：%@",[RORUtils transSecondToStandardFormat:lowSpeed]] forState:UIControlStateNormal];
    }
    if (responderTextField == highSpeedLabel){
        highSpeed = ([picker selectedRowInComponent:0]+2)*60 + [picker selectedRowInComponent:1];
        [self.highSpeedLabel setTitle:[NSString stringWithFormat:@"高速：%@",[RORUtils transSecondToStandardFormat:highSpeed]] forState:UIControlStateNormal];
    }
}

- (IBAction)hideKeyboard:(id)sender {
    [self.titleTextField resignFirstResponder];
}

- (IBAction)add2ListAction:(id)sender {
    Mission *mission = [Mission intiUnassociateEntity];
    if (trainingTypeSegment.selectionIndex == 0){
        mission.missionDistance = [NSNumber numberWithInt:distance*1000];
        mission.missionTime = [NSNumber numberWithInt:-1];
    } else {
        mission.missionDistance = [NSNumber numberWithInt:-1];
        mission.missionTime = [NSNumber numberWithInt:duration];
    }
//    mission.missionName = [NSString stringWithFormat:@"%@1", newPlan.planName];
    mission.missionTypeId = [NSNumber numberWithInt:ComplexTask];
    mission.suggestionMinSpeed = [RORUserUtils timePerKM2kmPerHour:lowSpeed];
    mission.suggestionMaxSpeed = [RORUserUtils timePerKM2kmPerHour:highSpeed];
    mission.lastUpdateTime = [NSDate date];
    mission.cycleTime = [NSNumber numberWithInt:frequency];
    mission.sequence = [NSNumber numberWithInt:contentList.count];
    
    [contentList addObject:mission];
    [self.tableView reloadData];
}

-(IBAction)showPicker:(id)sender{
    [self.titleTextField resignFirstResponder];
    [self initPicker:sender];
    self.coverView.alpha = 1;
}

//- (IBAction)trainingTypeChangedAction:(id)sender {
//    trainingType = self.trainingTypeSegment.selectedSegmentIndex;
//    if (trainingType == 0){
//        [self.trainingTypeSegmentBg setImage:[UIImage imageNamed:@"trainingTypeSeg_bg.png"]];
//    } else {
//        [self.trainingTypeSegmentBg setImage:[UIImage imageNamed:@"trainingTypeSeg_bg1.png"]];
//    }
//    [self initControls];
//}

#pragma mark - RORSegmentContorl delegate

-(void)SegmentValueChanged:(NSInteger)segmentIndex{
    //    UISegmentedControl *seg = (UISegmentedControl *)sender;
    trainingType = segmentIndex;
    switch (trainingType) {
        case 0:
            [self.trainingTypeSegmentBg setImage:[UIImage imageNamed:@"trainingTypeSeg_bg.png"]];
            break;
        case 1:
            [self.trainingTypeSegmentBg setImage:[UIImage imageNamed:@"trainingTypeSeg_bg1.png"]];
            break;
        default:
            break;
    };
    if (trainingType == 0)
        [durationLabel setTitle:[NSString stringWithFormat:@"定距：%@km", [NSNumber numberWithDouble:distance]] forState:UIControlStateNormal];
    else
        [durationLabel setTitle:[NSString stringWithFormat:@"计时：%@",[RORUtils transSecondToStandardFormat:duration]] forState:UIControlStateNormal];
}


-(BOOL) checkInput{
    if (self.titleTextField.text.length<=0){
        [self sendAlart:@"请输入训练名"];
        return NO;
    }
    
    return YES;
}

-(Plan *)createNewAdvancedPlan{
    if (![self checkInput]){
        return nil;
    }
    Plan *newPlan = [Plan intiUnassociateEntity];

    newPlan.planName = self.titleTextField.text;
    newPlan.totalMissions = [NSNumber numberWithInt:contentList.count+1];
    newPlan.planType = [NSNumber numberWithInt:PlanTypeComplex];
    newPlan.lastUpdateTime = [NSDate date];
    for (int i=0; i<contentList.count; i++){
        Mission* mission =[contentList objectAtIndex:i];
        mission.missionName = newPlan.planName;
        mission.sequence = [NSNumber numberWithInt:i];
    }
    newPlan.missionList = contentList;
    return newPlan;
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    if (responderTextField == durationLabel || responderTextField == lowSpeedLabel || responderTextField == highSpeedLabel)
        return 2;
    return 1;
}

- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (responderTextField == durationLabel){
        if ( trainingTypeSegment.selectionIndex == 0){
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
    if (responderTextField == frequencyLabel)
        return 7;
    if (responderTextField == self.lowSpeedLabel || responderTextField == self.highSpeedLabel){
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
    if (responderTextField == frequencyLabel)
        return [NSString stringWithFormat:@"%d", row+1];
    if (responderTextField == durationLabel){
        if ( trainingTypeSegment.selectionIndex == 0){
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
    if (responderTextField == self.lowSpeedLabel || responderTextField == self.highSpeedLabel){
        switch (component) {
            case 0:
                return [NSString stringWithFormat:@"%d",row+2];
            default:
                break;
        }
    }
    return [NSString stringWithFormat:@"%d",row];
    
}

//- (CGFloat)pickerView:(UIPickerView*)pickerView widthForComponent:(NSInteger)component{
//    if (component<3)
//        return 80;
//    return 40;
//}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    Mission *thisMission = [contentList objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"planDetailCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *sequenceLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *dateCommentLabel = (UILabel *)[cell viewWithTag:254];
    UILabel *trainingContentLabel = (UILabel *)[cell viewWithTag:102];
    UILabel *speedLabel = (UILabel*)[cell viewWithTag:103];
    
    sequenceLabel.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
//    if (indexPath.row ==0){
        dateCommentLabel.text = [NSString stringWithFormat:@"%d",thisMission.cycleTime.integerValue];
//    } else {
//        dateCommentLabel.text = [NSString stringWithFormat:@"上次训练完成后的%d天内完成", thisMission.cycleTime.integerValue];
//    }
    if (thisMission.missionDistance.doubleValue>=0) {
        trainingContentLabel.text = [NSString stringWithFormat:@"定距跑：%@",[RORUtils outputDistance:thisMission.missionDistance.doubleValue]];
    } else {
        trainingContentLabel.text = [NSString stringWithFormat:@"计时跑：%@",  [RORUtils transSecondToStandardFormat:thisMission.missionTime.doubleValue]];
    }
    
    speedLabel.text = [NSString stringWithFormat:@"配速：%@ ~ %@", [RORUserUtils formatedSpeed:thisMission.suggestionMaxSpeed.doubleValue], [RORUserUtils formatedSpeed:thisMission.suggestionMinSpeed.doubleValue]];
    
    return cell;
}

//为cell添加删除按钮
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [contentList removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

#pragma mark Training Picker Cover View Delegate
- (void) didFinishPicking{
    [self hideCover:self];
}



@end
