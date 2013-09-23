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
//    self.backButton.alpha = 0;
//    self.coverView.alpha = 0;
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
}

- (void)saveAction {
    NSDictionary *saveDict = [NSDictionary dictionaryWithObjectsAndKeys:content.attributes.height, @"height",
                             content.attributes.weight, @"weight",
                             content.sex, @"sex", nil];
    [RORUserUtils writeToUserSettingsPList:saveDict];
    if([RORUserUtils getUserId].integerValue > 0){
        [RORUserServices updateUserInfo:saveDict];
    }
}

- (IBAction)selectSexAction:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    switch (seg.selectedSegmentIndex) {
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

-(IBAction)submitAction:(id)sender{
    [self saveAction];
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
    UITextField *textField = (UITextField *)sender;
    UIView *temp = [textField superview];
    while (![temp isKindOfClass:[UITableViewCell class]]) {
        temp = [temp superview];
    }
    UITableViewCell *cell = (UITableViewCell *)temp;

    NSIndexPath *indexPath = [self.table indexPathForCell:(UITableViewCell*)cell];
    switch (indexPath.row) {
        case HEIGHT_PICKER:
        {
            double dec = textField.text.doubleValue;
            if (dec<120 || dec>250){
                [self sendAlart:@"身高输入不对"];
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
                return;
            }
            newWeight = dec;
            break;
        }
        default:
            break;
    }
    [sender resignFirstResponder];
}

-(IBAction)backgroundTap:(id)sender{
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
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
            titleLabel.text = @"身高(cm)";
            newHeight = content.attributes.height.doubleValue;
            UITextField *textField = (UITextField *)[cell viewWithTag:2];
            textField.text = [NSString stringWithFormat:@"%.1f",newHeight];
            break;
        }
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"plainCell" forIndexPath:indexPath];
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
            titleLabel.text = @"体重(kg)";
            newWeight = content.attributes.weight.doubleValue;
            UITextField *textField = (UITextField *)[cell viewWithTag:2];
            textField.text = [NSString stringWithFormat:@"%.1f",newWeight];
            break;
        }
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"sexCell" forIndexPath:indexPath];
            newSex = content.sex;
            UISegmentedControl *seg = (UISegmentedControl *)[cell viewWithTag:1];
            [seg addTarget:self action:@selector(selectSexAction:) forControlEvents:UIControlEventValueChanged];
            if ([content.sex isEqualToString:@"男"]){
                [seg setSelectedSegmentIndex:0];
            } else if ([content.sex isEqualToString:@"女"]){
                [seg setSelectedSegmentIndex:2];
            } else{
                [seg setSelectedSegmentIndex:1];
            }
            break;
        }
        default:
            break;
    }
    
    return cell;
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
