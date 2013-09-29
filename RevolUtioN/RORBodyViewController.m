//
//  RORBodyViewController.m
//  RevolUtioN
//
//  Created by Bjorn on 13-8-27.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORBodyViewController.h"
#import "FTAnimation.h"
#import "RORMoreViewController.h"
#import "RORLoginViewController.h"

#define TITLE_TAG 1
#define TEXTFIELD_TAG 2
#define UNIT_TAG 3

@interface RORBodyViewController ()

@end

@implementation RORBodyViewController
@synthesize content;
@synthesize delegate;

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

    if ([delegate isKindOfClass:[RORLoginViewController class]]){
        self.backButton.alpha = 0;
    }
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collepseKeyboard:)] ;
//    [self.table.backgroundView addGestureRecognizer:tap];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
//    [self setCoverView:nil];
//    [self setPicker:nil];
    [self setTable:nil];
    [super viewDidUnload];
}

-(void)loadData{
    content = [User_Base intiUnassociateEntity];
    User_Attributes *attributes = [User_Attributes intiUnassociateEntity];
    content.attributes = attributes;
    NSMutableDictionary *settinglist = [RORUserUtils getUserSettingsPList];
    content.sex = [settinglist valueForKey:@"sex"];
    content.attributes.height =[settinglist valueForKey:@"height"];
    content.attributes.weight = [settinglist valueForKey:@"weight"];
    isValid = YES;
}

- (void)saveAction {
//    [self collepseKeyboard:[[self.table cellForRowAtIndexPath:selection] viewWithTag:2]];
    
    if (newHeight<120 || newHeight>250 || newWeight<30 || newWeight>150){
        isValid = NO;
        [self sendAlart:@"信息填写有误"];
        return;
    } else
        isValid = YES;
    
    content.attributes.height = [NSNumber numberWithDouble:newHeight];
    content.attributes.weight = [NSNumber numberWithDouble:newWeight];
    
    NSDictionary *saveDict = [NSDictionary dictionaryWithObjectsAndKeys:content.attributes.height, @"height",
                             content.attributes.weight, @"weight",
                             content.sex, @"sex", nil];
    [RORUserUtils writeToUserSettingsPList:saveDict];
    if([RORUserUtils getUserId].integerValue > 0){
        [RORUserServices updateUserInfo:saveDict];
    }
}

//- (IBAction)selectSexAction:(id)sender {
//    UISegmentedControl *seg = (UISegmentedControl *)sender;
//    switch (seg.selectedSegmentIndex) {
//        case 0:
//            content.sex = @"男";
//            break;
//        case 1:
//            content.sex = @"未知";
//            break;      
//        case 2:
//            content.sex = @"女";
//            break;
//        default:
//            break;
//    };
//}

-(IBAction)submitAction:(id)sender{
    [self saveAction];
    if (!isValid) return;
    [self backAction:sender];
}

-(IBAction)backAction:(id)sender{
    if ([delegate isKindOfClass:[RORLoginViewController class]]){
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)collepseKeyboard:(id)sender {
    [sender resignFirstResponder];
}

-(IBAction)textFieldDidEndEditing:(id)sender
{
    UITextField *textField = (UITextField *)sender;
//    NSLog(@"%@", textField.text);
    UITableViewCell *cell = [self cellForTextField:textField];
    
    NSIndexPath *indexPath = [self.table indexPathForCell:(UITableViewCell*)cell];
    switch (indexPath.row) {
        case HEIGHT_PICKER:
        {
            double dec = textField.text.doubleValue;
            if (dec<120 || dec>250){
                [self sendAlart:@"身高输入不对"];
                isValid = NO;
                textField.text = cache;
                return;
            }
            newHeight = dec;
            break;
        }
        case WEIGHT_PICKER:
        {
            double dec = textField.text.doubleValue;
            if (dec<30 || dec>150){
                [self sendAlart:@"体重输入不对"];
                isValid = NO;
                textField.text = cache;
                return;
            }
            newWeight = dec;
            break;
        }
        default:
            break;
    }

}

-(IBAction)backgroundTap:(id)sender{
    UITextField *textField = (UITextField *)[[self.table cellForRowAtIndexPath:selection] viewWithTag:TEXTFIELD_TAG];
    [self collepseKeyboard:textField];
}

-(IBAction)startEditingAction:(id)sender{
    UITextField *textField = (UITextField *)sender;
    UITableViewCell *cell = [self cellForTextField:textField];
    selection = [self.table indexPathForCell:(UITableViewCell*)cell];
    cache = textField.text;
    textField.text = @"";
}

-(UITableViewCell *)cellForTextField:(UITextField*)textField{
    UIView *temp = [textField superview];
    while (![temp isKindOfClass:[UITableViewCell class]]) {
        temp = [temp superview];
    }
    return (UITableViewCell *)temp;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"plainCell" forIndexPath:indexPath];
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:TITLE_TAG];
            titleLabel.text = @"身高";
            
            newHeight = content.attributes.height.doubleValue;
            UITextField *textField = (UITextField *)[cell viewWithTag:TEXTFIELD_TAG];
            [textField addTarget:self action:@selector(startEditingAction:) forControlEvents:UIControlEventEditingDidBegin];
            [textField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
            textField.text = [NSString stringWithFormat:@"%.1f",newHeight];
            
            UILabel *unitLabel = (UILabel *)[cell viewWithTag:UNIT_TAG];
            unitLabel.text = @"(cm)";
            
            [RORUtils setFontFamily:CHN_WRITTEN_FONT forView:titleLabel andSubViews:NO];
            [RORUtils setFontFamily:ENG_WRITTEN_FONT forView:textField andSubViews:YES];
            
            break;
        }
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"plainCell" forIndexPath:indexPath];
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:TITLE_TAG];
            titleLabel.text = @"体重";
            
            newWeight = content.attributes.weight.doubleValue;
            UITextField *textField = (UITextField *)[cell viewWithTag:TEXTFIELD_TAG];
            
            [textField addTarget:self action:@selector(startEditingAction:) forControlEvents:UIControlEventEditingDidBegin];
            [textField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
            
            textField.text = [NSString stringWithFormat:@"%.1f",newWeight];
            
            UILabel *unitLabel = (UILabel *)[cell viewWithTag:UNIT_TAG];
            unitLabel.text = @"(kg)";

            [RORUtils setFontFamily:CHN_WRITTEN_FONT forView:titleLabel andSubViews:NO];
            [RORUtils setFontFamily:ENG_WRITTEN_FONT forView:textField andSubViews:YES];
            
            break;
        }
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"sexCell" forIndexPath:indexPath];
            newSex = content.sex;
//            UISegmentedControl *seg = (UISegmentedControl *)[cell viewWithTag:1];
            RORSegmentControl *segment = (RORSegmentControl *)[cell viewWithTag:2];
            if (!segment){
                segment = [[RORSegmentControl alloc]initWithFrame:CGRectMake(33, 20, 204, 29) andSegmentNumber:3];
                segment.delegate = self;
                [segment setSegmentTitle:@"男" withIndex:0];
                [segment setSegmentTitle:@"很矛盾" withIndex:1];
                [segment setSegmentTitle:@"女" withIndex:2];
                [segment setTag:2];
                [cell addSubview:segment];
            }
            
            if ([content.sex isEqualToString:@"男"]){
                [segment selectSegmentAtIndex:0];
            } else if ([content.sex isEqualToString:@"女"]){
                [segment selectSegmentAtIndex:2];
            } else{
                [segment selectSegmentAtIndex:1];
            }
            
            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark - RORSegmentContorl delegate

-(void)SegmentValueChanged:(NSInteger)segmentIndex{
//    UISegmentedControl *seg = (UISegmentedControl *)sender;
    switch (segmentIndex) {
        case 0:
            content.sex = @"男";
            break;
        case 1:
            content.sex = @"未知";
            break;
        case 2:
            content.sex = @"女";
            break;
        default:
            break;
    };
}

#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row>1)
//        return;
//    selection = indexPath.row;
//    [self.picker reloadAllComponents];
//    
//    double doubleValue = 0.0;
//    int intValue = 0;
//    switch (indexPath.row) {
//        case HEIGHT_PICKER:
//        {
//            doubleValue = content.attributes.height.doubleValue;
//            intValue = (int)doubleValue;
//            break;
//        }
//        case WEIGHT_PICKER:
//        {
//            doubleValue = content.attributes.weight.doubleValue;
//            intValue = (int)doubleValue;
//            [self.picker selectRow:intValue/100 inComponent:0 animated:NO];
//            break;
//        }
//    }
//    [self.picker selectRow:(intValue%100)/10 inComponent:1 animated:NO];
//    [self.picker selectRow:(intValue%100)%10 inComponent:2 animated:NO];
//    [self.picker selectRow:round(doubleValue-intValue) inComponent:3 animated:NO];
////    [self showCoverView];
//}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    isChecked[indexPath.row] = NO;
//    [cell viewWithTag:FILTER_TABLECELL_IMAGE].alpha = 0;
//}
//
//#pragma mark -
//#pragma mark Picker Data Source Methods
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
//    return 4;
//}
//
//- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
//    switch (component) {
//        case 0:
//        {
//            return 2;
//        }
//        case 1:
//        case 2:
//            return 10;
//        case 3:
//            return 2;
//        default:
//            break;
//    }
//    return 0;
//}
//
//#pragma mark Picker Delegate Methods
//- (NSString *)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    switch (component) {
//        case 0:
//        {
//            if(selection == HEIGHT_PICKER)
//                return [NSString stringWithFormat:@"%d",row+1];
//            else
//                return [NSString stringWithFormat:@"%d",row];
//        }
//        case 1:
//        case 2:
//            return [NSString stringWithFormat:@"%d",row];
//        case 3:
//            return [NSString stringWithFormat:@".%d",row*5];
//        default:
//            break;
//    }
////    }
//    return nil;
//}
//- (CGFloat)pickerView:(UIPickerView*)pickerView widthForComponent:(NSInteger)component{
//    if (component<3)
//        return 80;
//    return 40;
//}
//
@end
