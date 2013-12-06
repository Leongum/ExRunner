//
//  RORAdvancedViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-11-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORAdvancedViewController.h"

@interface RORAdvancedViewController ()

@end

@implementation RORAdvancedViewController


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
    
    self.titleLabel.text = self.plan.planName;
    self.planIdLabel.text = [NSString stringWithFormat:@"训练编号：%@",self.plan.planId];

    contentList = self.plan.missionList;
    
    if ([self isCollectAvailable]){
        self.collectButton.enabled = YES;
        [self refreshCollectButton:self.collectButton];
        [self.collectButton addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        self.collectButton.enabled = NO;
        [self refreshCollectButton:self.collectButton];
    }
    
    if (self.planNext)
        self.operateButton.enabled = NO;
    else{
        self.operateButton.enabled = YES;
        [self.operateButton addTarget:self action:@selector(operateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [self.collectButton addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
    UILabel *dateCommentLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *trainingContentLabel = (UILabel *)[cell viewWithTag:102];
    UILabel *speedLabel = (UILabel*)[cell viewWithTag:103];
    
    sequenceLabel.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
    if (indexPath.row ==0){
        dateCommentLabel.text = [NSString stringWithFormat:@"接受训练后的%d天内完成",thisMission.cycleTime.integerValue];
    } else {
        dateCommentLabel.text = [NSString stringWithFormat:@"上次训练完成后的%d天内完成", thisMission.cycleTime.integerValue];
    }
    if (thisMission.missionDistance.doubleValue>=0) {
        trainingContentLabel.text = [NSString stringWithFormat:@"定距跑：%@",[RORUtils outputDistance:thisMission.missionDistance.doubleValue]];
    } else {
        trainingContentLabel.text = [NSString stringWithFormat:@"计时跑：%@",  [RORUtils transSecondToStandardFormat:thisMission.missionTime.doubleValue]];
    }
    speedLabel.text = [NSString stringWithFormat:@"配速：%@ ~ %@", [RORUserUtils formatedSpeed:thisMission.suggestionMaxSpeed.doubleValue], [RORUserUtils formatedSpeed:thisMission.suggestionMinSpeed.doubleValue]];
    
    return cell;
}
@end
