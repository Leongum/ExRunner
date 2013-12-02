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
    contentList = self.plan.missionList;
    
    if (planNext)
        self.operateButton.enabled = 0;
    else{
        self.operateButton.enabled = 1;
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
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:102];
    UILabel *durationLabel = (UILabel *)[cell viewWithTag:105];
    UILabel *distanceLabel = (UILabel *)[cell viewWithTag:104];
    
    sequenceLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    dateCommentLabel.text = indexPath.row==0?@"训练开始后":@"上一次完成后";
    durationLabel.text = [RORUtils transSecondToStandardFormat:thisMission.missionTime.integerValue];
    distanceLabel.text = [RORUtils outputDistance:thisMission.missionDistance.doubleValue];
    dateLabel.text = [NSString stringWithFormat:@"%d天内完成", thisMission.cycleTime.integerValue];
    return cell;
}
@end
