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
    
    if (self.plan.sharedPlan.integerValue == SharedPlanSystem){
        self.certifiedIcon.alpha = 1;
//        self.composerLabel.alpha = 0;
        self.descriptionLabel.text = @"";//以后填
    } else {
        self.certifiedIcon.alpha = 0;
//        self.composerLabel.alpha = 1;
//        self.composerLabel.text = [NSString stringWithFormat:@"创建者：%@", self.plan.planShareUserName];
        self.descriptionLabel.text = [NSString stringWithFormat:@"创建者：%@(%@)", self.plan.planShareUserName, [RORUtils addEggache:self.plan.planShareUserId]];
    }
    
    contentList = self.plan.missionList;
    
    [self.collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectButton setTitle:@"已收藏" forState:UIControlStateDisabled];

    [self.collectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.collectButton setTitleColor:COLOR_MOSS forState:UIControlStateDisabled];
    [self.operateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.operateButton setTitleColor:COLOR_MOSS forState:UIControlStateDisabled];

    if ([self isCollectAvailable]){
        self.collectButton.enabled = YES;
        [self.collectButton addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        self.collectButton.enabled = NO;
    }
    
    if (self.planNext)
        self.operateButton.enabled = NO;
    else{
        self.operateButton.enabled = YES;
        [self.operateButton addTarget:self action:@selector(operateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [self.collectButton addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.plan.planDescription)
        self.infoButton.alpha = 1;
    else
        self.infoButton.alpha = 0;
    
    tipPadView = [[RORPlanCommentView alloc]initWithFrame:self.view.frame andY:self.infoButton.frame.origin.y+self.infoButton.frame.size.height];
    [self.view addSubview:tipPadView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showInfoAction:(id)sender {
    [tipPadView showComment:self.plan.planDescription];
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
    UILabel *dateCommentLabel = (UILabel *)[cell viewWithTag:254];
    UILabel *trainingContentLabel = (UILabel *)[cell viewWithTag:102];
    UILabel *speedLabel = (UILabel*)[cell viewWithTag:103];
    
    sequenceLabel.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
    dateCommentLabel.text = [NSString stringWithFormat:@"%d",thisMission.cycleTime.integerValue];
    if (thisMission.missionDistance.doubleValue>=0) {
        trainingContentLabel.text = [NSString stringWithFormat:@"定距跑：%@",[RORUtils outputDistance:thisMission.missionDistance.doubleValue]];
    } else {
        trainingContentLabel.text = [NSString stringWithFormat:@"计时跑：%@",  [RORUtils transSecondToStandardFormat:thisMission.missionTime.doubleValue]];
    }
    speedLabel.text = [NSString stringWithFormat:@"配速：%@ ~ %@", [RORUserUtils formatedSpeed:thisMission.suggestionMaxSpeed.doubleValue], [RORUserUtils formatedSpeed:thisMission.suggestionMinSpeed.doubleValue]];
    
    return cell;
}
@end
