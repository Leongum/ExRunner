//
//  RORMoreViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORMoreViewController.h"
#import "RORUserServices.h"
#import "RORAppDelegate.h"

@interface RORMoreViewController ()

@end

@implementation RORMoreViewController
@synthesize context;
@synthesize moreTableView;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [moreTableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
}

- (void)viewDidUnload {
    [self setMoreTableView:nil];
    [super viewDidUnload];
}

-(IBAction)changeSpeedType:(id)sender{
    NSMutableDictionary *settinglist = [RORUserUtils getUserSettingsPList];
    UISegmentedControl *seg = (UISegmentedControl*)sender;
    [settinglist setValue:[NSNumber numberWithInteger:[seg selectedSegmentIndex]] forKey:@"speedType"];
    [RORUserUtils writeToUserSettingsPList:settinglist];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = nil;
    UITableViewCell *cell = nil;

    switch (indexPath.row) {
        case 0:
        {
            identifier = @"accountCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel *label = (UILabel*)[cell viewWithTag:1];
            User_Base *userInfo = [RORUserServices fetchUser:[RORUserUtils getUserId]];
            label.text =  userInfo.nickName;
            break;
        }
        case 1:
        {
            identifier = @"bodyCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel *label = (UILabel*)[cell viewWithTag:1];
            label.text = @"身体参数";
            break;
        }
        case 2:
        {
            NSMutableDictionary *settinglist = [RORUserUtils getUserSettingsPList];
            NSString *syncMode = [settinglist valueForKey:@"uploadMode"];
            identifier = @"syncCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel *label = (UILabel*)[cell viewWithTag:1];
            UISwitch *switchCtrl = (UISwitch *)[cell viewWithTag:2];
            [switchCtrl addTarget:self action:@selector(syncModeSwitchChangeHandler:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchCtrl;
            if([syncMode isEqualToString:DEFAULT_NET_WORK_MODE]){
                ((UISwitch *)cell.accessoryView).on = 1;
                 label.text = SYNC_MODE_ALL;
            }
            else{
                ((UISwitch *)cell.accessoryView).on = 0;
                label.text = SYNC_MODE_WIFI;
            }
            break;
        }
        case 3:
        {
            identifier = @"speedCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UISegmentedControl *seg = (UISegmentedControl *)[cell viewWithTag:2];
            
            NSMutableDictionary *settinglist = [RORUserUtils getUserSettingsPList];
            NSNumber *speedType = [settinglist valueForKey:@"speedType"];
            if (speedType != nil){
                NSInteger st = speedType.integerValue;
                [seg setSelectedSegmentIndex:st];
            }
            [seg addTarget:self action:@selector(changeSpeedType:) forControlEvents:UIControlEventValueChanged];
            break;
        }
    }
    [RORUtils setFontFamily:CHN_PRINT_FONT forView:cell andSubViews:YES];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row== 2)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UISwitch *switchCtrl = (UISwitch *)[cell viewWithTag:2];
        [switchCtrl setOn:!switchCtrl.on animated:YES];
//        [self syncModeSwitchChangeHandler:switchCtrl];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)syncModeSwitchChangeHandler:(UISwitch *)sender
{
    NSMutableDictionary *settingDict = [[NSMutableDictionary alloc] init];
    if (sender.on)
    {   
        [settingDict setValue:DEFAULT_NET_WORK_MODE forKey:@"uploadMode"];
    }
    else
    {
        [settingDict setValue:NET_WORK_MODE_WIFI forKey:@"uploadMode"];
    }
    [RORUserUtils writeToUserSettingsPList:settingDict];
    [moreTableView reloadData];
}

@end
