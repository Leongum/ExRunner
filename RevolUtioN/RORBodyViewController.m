//
//  RORBodyViewController.m
//  RevolUtioN
//
//  Created by Bjorn on 13-8-27.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORBodyViewController.h"
#import "FTAnimation.h"

@interface RORBodyViewController ()

@end

@implementation RORBodyViewController
@synthesize content;

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
    self.coverView.alpha = 0;
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCoverView:nil];
    [self setPicker:nil];
    [self setTable:nil];
    [super viewDidUnload];
}

-(void)loadData{
    content = [RORUserServices fetchUser:[RORUserUtils getUserId]];
}

- (void)saveAction {
    NSDictionary *saveDict = [NSDictionary dictionaryWithObjectsAndKeys:content.attributes.height, @"height",
                             content.attributes.weight, @"weight",
                             content.sex, @"sex", nil];
    [RORUserServices updateUserInfo:saveDict];
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

-(void)hideCoverView{
    [Animations fadeOut:self.coverView andAnimationDuration:0.3 fromAlpha:1 andWait:NO];
    [Animations fadeIn:self.backButton andAnimationDuration:0.3 toAlpha:1 andWait:YES];
}

-(void)showCoverView{
    self.coverView.alpha = 1;
    [self.coverView popIn:0.4 delegate:nil];
    
    //    [Animations fadeIn:self.coverView andAnimationDuration:0.3 toAlpha:1 andWait:NO];
    [Animations fadeOut:self.backButton andAnimationDuration:0.3 fromAlpha:1 andWait:YES];
}

- (IBAction)coverViewTap:(id)sender {
    double value = [self.picker selectedRowInComponent:0]*100 +
                [self.picker selectedRowInComponent:1]*10 +
                [self.picker selectedRowInComponent:2] +
                [self.picker selectedRowInComponent:3]*0.5;
    switch (selection) {
        case HEIGHT_PICKER:
        {
            value += 100;
            content.attributes.height = [NSNumber numberWithDouble:value];
            break;
        }
        case WEIGHT_PICKER:
        {
            content.attributes.weight = [NSNumber numberWithDouble:value];
            break;
        }
        default:
            break;
    }
    [self.table reloadData];
    [self hideCoverView];
}

-(IBAction)backAction:(id)sender{
    [self saveAction];
    [super backAction:sender];
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
            cell.textLabel.text = @"身高(cm)";
            newHeight = content.attributes.height.doubleValue;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f",newHeight];
            break;
        }
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"plainCell" forIndexPath:indexPath];
            cell.textLabel.text = @"体重(kg)";
            newWeight = content.attributes.weight.doubleValue;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f",newWeight];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>1)
        return;
    selection = indexPath.row;
    [self.picker reloadAllComponents];
    
    double doubleValue = 0.0;
    int intValue = 0;
    switch (indexPath.row) {
        case HEIGHT_PICKER:
        {
            doubleValue = content.attributes.height.doubleValue;
            intValue = (int)doubleValue;
            break;
        }
        case WEIGHT_PICKER:
        {
            doubleValue = content.attributes.weight.doubleValue;
            intValue = (int)doubleValue;
            [self.picker selectRow:intValue/100 inComponent:0 animated:NO];
            break;
        }
    }
    [self.picker selectRow:(intValue%100)/10 inComponent:1 animated:NO];
    [self.picker selectRow:(intValue%100)%10 inComponent:2 animated:NO];
    [self.picker selectRow:round(doubleValue-intValue) inComponent:3 animated:NO];
    [self showCoverView];
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    isChecked[indexPath.row] = NO;
//    [cell viewWithTag:FILTER_TABLECELL_IMAGE].alpha = 0;
//}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    return 4;
}

- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
        {
            return 2;
        }
        case 1:
        case 2:
            return 10;
        case 3:
            return 2;
        default:
            break;
    }
    return 0;
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            if(selection == HEIGHT_PICKER)
                return [NSString stringWithFormat:@"%d",row+1];
            else
                return [NSString stringWithFormat:@"%d",row];
        }
        case 1:
        case 2:
            return [NSString stringWithFormat:@"%d",row];
        case 3:
            return [NSString stringWithFormat:@".%d",row*5];
        default:
            break;
    }
//    }
    return nil;
}
- (CGFloat)pickerView:(UIPickerView*)pickerView widthForComponent:(NSInteger)component{
    if (component<3)
        return 80;
    return 40;
}

@end
