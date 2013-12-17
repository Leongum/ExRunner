//
//  RORTraineesViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-11-5.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORTraineesViewController.h"
#import "FTAnimation.h"
#import "Animations.h"

#define FRAME_OF_TABLEVIEWTRAINEE CGRectMake(20, 253, 280, 200)
#define FRAME_OF_TABLEVIEWFRIENDS CGRectMake(20, 193, 280, 200)
#define ROWS 10
#define ANIMATION_DURATION_POPUP 0.2

@interface RORTraineesViewController ()

@end

@implementation RORTraineesViewController
@synthesize planNext;

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
    [Animations frameAndShadow:self.partnerView];
    
    tableViewHeight = 155;
    
    self.tableViewContainerView.frame = CGRectMake(self.tableViewContainerView.frame.origin.x, self.tableViewContainerView.frame.origin.y, self.tableViewContainerView.frame.size.width, tableViewHeight);

    self.tableViewContainerView.alpha = 0;
    
    traineeBtnInitY = self.showTraineesButton.center.y;
    tableViewInitY = self.tableViewContainerView.center.y;
    
    tableViewPathLength = self.showTraineesButton.frame.origin.y + self.showTraineesButton.frame.size.height - self.showFriendsButton.frame.origin.y - self.showFriendsButton.frame.size.height;
    
    traineeBtnPathLength = self.tableViewContainerView.frame.origin.y+self.tableViewContainerView.frame.size.height - tableViewPathLength - self.showFriendsButton.frame.origin.y - self.showFriendsButton.frame.size.height - 2;
    
    friendList = [RORPlanService getTopUsingByUserId:[RORUserUtils getUserId] withPageNo:[NSNumber numberWithInt:0]];
    for (Plan_Run_History *thisPlanRun in friendList){
//        if (thisPlanRun.userId.integerValue == [RORUserUtils getUserId].integerValue)
//            [friendList removeObject:thisPlanRun];
    }
    traineeList = [RORPlanService getTopUsingByPlanId:planNext.planId withPageNo:[NSNumber numberWithInt:0]];
    Plan_Run_History *toDelete;
    for (Plan_Run_History *thisPlanRun in traineeList){
        if (thisPlanRun.userId.integerValue == [RORUserUtils getUserId].integerValue)
            toDelete = thisPlanRun;
    }
    [traineeList removeObject:toDelete];
    
    friendPageCount = 1;
    traineePageCount = 1;
    
    UIButton *fixonButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 55)];
    [fixonButton setTitle:@"锁定" forState:UIControlStateNormal];
    [fixonButton addTarget:self action:@selector(fixonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.coverView.alpha = 0;
    
    [self initFixonView];
}

-(void)initFixonView{
    NSDictionary *dict = [RORUserUtils getUserInfoPList];
    NSNumber *fixonUserId = [RORDBCommon getNumberFromId:[dict objectForKey:@"TrainingFixonUserId"]];
    if (fixonUserId && fixonUserId.integerValue>0) {
        self.partnerView.alpha = 1;
        fixonPlanRunHistory = [RORPlanService getUserLastUpdatePlan:fixonUserId];
        [self fillCellView:self.partnerView withPlanRunHistory:fixonPlanRunHistory];
        self.removeFixonButton.alpha = 1;
    } else {
        self.partnerView.alpha = 0;
        self.removeFixonButton.alpha = 0;
    }
}

-(void)viewDidAppear:(BOOL)animated{
//    self.tableView.contentSize = CGSizeMake(0, tableViewHeight);
    
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:ROWS inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showTraineesAction:(id)sender {
    double duration = 0.5;
    
//    self.tableView.frame.size.height/2 + self.showTraineesButton.frame.size.height/2 + 
    UIButton *btn = (UIButton *)sender;

    if (btn == self.showFriendsButton){
        if (showWhich == SHOWWHICH_FRIENDS)
            return;
        self.tableViewContainerView.alpha = 0;
        
        showWhich = SHOWWHICH_FRIENDS;
        
        if (self.showTraineesButton.center.y == traineeBtnInitY){
            [Animations moveDown:self.showTraineesButton andAnimationDuration:duration/2 andWait:NO andLength:traineeBtnPathLength];
        }
        if (self.tableViewContainerView.center.y==tableViewInitY){
            [Animations moveUp:self.tableViewContainerView andAnimationDuration:0 andWait:NO andLength:tableViewPathLength];
        }
        contentList = friendList;
        tableCount = friendList.count;
    } else{
        if (showWhich == SHOWWHICH_TRAINEES)
            return;
        self.tableViewContainerView.alpha = 0;
        
        showWhich = SHOWWHICH_TRAINEES;

        if (!(self.showTraineesButton.center.y == traineeBtnInitY)){
            [Animations moveUp:self.showTraineesButton andAnimationDuration:0 andWait:YES andLength:traineeBtnPathLength];
        }
        if (!(self.tableViewContainerView.center.y==tableViewInitY)){
            [Animations moveDown:self.tableViewContainerView andAnimationDuration:0 andWait:NO andLength:tableViewPathLength];
        }
        contentList = traineeList;
        tableCount = traineeList.count;
        NSLog(@"=================\n%@", traineeList);
    }
    
    [self.tableViewContainerView expand:duration delegate:self startSelector:@selector(showTableView) stopSelector:nil];

//    if (tableCount>0)
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:tableCount inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
    [self.tableView reloadData];
}

-(IBAction)fixonAction :(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:popUpCellView];
    fixonPlanRunHistory = (Plan_Run_History *)[contentList objectAtIndex:indexPath.row];
    
    NSDictionary *saveDict = [NSDictionary dictionaryWithObjectsAndKeys:fixonPlanRunHistory.userId, @"TrainingFixonUserId", nil];
    [RORUserUtils writeToUserInfoPList:saveDict];
    
    [popUpView popDown:ANIMATION_DURATION_POPUP delegate:self targetPoint:self.partnerView.center startSelector:nil stopSelector:@selector(afterFixonAction:)];
    [self.coverView fadeOut:ANIMATION_DURATION_POPUP delegate:self];
    self.coverView.alpha = 0;
}

-(IBAction)afterFixonAction:(id)sender{
    [self hidePopUpView:sender];
    self.partnerView.alpha = 1;
    [self.partnerView fadeIn:ANIMATION_DURATION_POPUP delegate:self];
    [self fillCellView:self.partnerView withPlanRunHistory:fixonPlanRunHistory];
    self.removeFixonButton.alpha = 1;
}

-(void)fillCellView:(UIView *)view withPlanRunHistory:(Plan_Run_History*)thisPlanRun{
    NSString *username = thisPlanRun.nickName;
    NSString *planName = thisPlanRun.planName;
    NSString *process = [NSString stringWithFormat:@"%d/%d",
                         thisPlanRun.totalMissions.integerValue - thisPlanRun.remainingMissions.integerValue,
                         thisPlanRun.totalMissions.integerValue];
    
    UILabel *userNameLabel = (UILabel *)[view viewWithTag:100];
    UILabel *planNameLabel = (UILabel *)[view viewWithTag:102];
    UILabel *processLabel = (UILabel *)[view viewWithTag:101];
    userNameLabel.text = username;
    planNameLabel.text = planName;
    processLabel.text = process;
}

-(IBAction)cellSelectAction:(id)sender{
    
    popUpCellView = (UITableViewCell *)sender;
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(popUpCellView.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(popUpCellView.frame.size);
    }
    //获取图像
    [popUpCellView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    popUpView = [[UIImageView alloc]initWithImage:image];
    
    popUpView.frame = [self.tableView convertRect:popUpCellView.frame toView:self.view];
    popUpFrom = popUpView.center;
//    popUpView.frame = CGRectMake(0, 0, popUpView.frame.size.width*1.1, popUpView.frame.size.height*1.1);
    popUpView.frame = CGRectMake(0, 0, self.partnerView.frame.size.width*1.05, self.partnerView.frame.size.height*1.1);

    popUpView.center = popUpFrom;
    [self.view addSubview:popUpView];
    popUpView.alpha = 1;
    [popUpView popUp:ANIMATION_DURATION_POPUP delegate:self targetPoint:self.coverView.center];
    
    self.coverView.alpha = 1;
    [self.coverView fadeIn:ANIMATION_DURATION_POPUP delegate:self];
    
    popUpCellView.alpha =0;
}

-(IBAction)hideCoverView:(id)sender{
    [popUpView popDown:ANIMATION_DURATION_POPUP delegate:self targetPoint:popUpFrom startSelector:nil stopSelector:@selector(hidePopUpView:)];
    [self.coverView fadeOut:ANIMATION_DURATION_POPUP delegate:self];
    self.coverView.alpha = 0;
}

-(IBAction)hidePopUpView:(id)sender{
    [popUpView removeFromSuperview];
    popUpCellView.alpha = 1;
}

-(void)showTableView{
    self.tableViewContainerView.alpha = 1;
}

-(void)hideTableView{
    self.tableViewContainerView.alpha = 0;
}

-(IBAction)refreshTableAction:(id)sender{
    switch (showWhich) {
        case SHOWWHICH_FRIENDS:
        {
            NSMutableArray *newArray = [RORPlanService getTopUsingByUserId:[RORUserUtils getUserId] withPageNo:[NSNumber numberWithInt:friendPageCount++]];
            if (newArray.count==0){
                friendPageCount = -1;
            }
            for (Plan_Run_History *thisPlanRun in newArray){
                if (thisPlanRun.userId.integerValue == [RORUserUtils getUserId].integerValue)
                    [newArray removeObject:thisPlanRun];
            }

            [friendList addObjectsFromArray: newArray];
            break;
        }
        case SHOWWHICH_TRAINEES:
        {
            NSMutableArray *newArray = [RORPlanService getTopUsingByPlanId:planNext.planId withPageNo:[NSNumber numberWithInt:traineePageCount++]];
            if (newArray.count==0){
                traineePageCount = -1;
            }
            for (Plan_Run_History *thisPlanRun in newArray){
                if (thisPlanRun.userId.integerValue == [RORUserUtils getUserId].integerValue)
                    [newArray removeObject:thisPlanRun];
            }
            
            [traineeList addObjectsFromArray:newArray];
            
            break;
        }
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark - undo fixon

-(IBAction)unFixonAction:(id)sender{
    NSDictionary *saveDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:-1], @"TrainingFixonUserId", nil];
    [RORUserUtils writeToUserInfoPList:saveDict];
    [self.partnerView flyOut:0.618 delegate:self];
    
    self.removeFixonButton.alpha = 0;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (showWhich == 0)
        return 0;
    
    return contentList.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    //获取更多按钮
    if (indexPath.row == contentList.count){
        static NSString *CellIdentifier = @"refreshCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UIButton *refreshButton = (UIButton *)[cell viewWithTag:200];
        if (tableCount == 0){
            [refreshButton setTitle:@"目前好像没有" forState:UIControlStateNormal];
            [refreshButton removeTarget:self action:@selector(refreshTableAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if ((showWhich == SHOWWHICH_FRIENDS && friendPageCount <0)||(showWhich == SHOWWHICH_TRAINEES && traineePageCount<0)){
            [refreshButton setTitle:@"只有这么多了" forState:UIControlStateNormal];
            [refreshButton removeTarget:self action:@selector(refreshTableAction:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [refreshButton setTitle:@"再来10个" forState:UIControlStateNormal];
            [refreshButton addTarget:self action:@selector(refreshTableAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
    
    Plan_Run_History *thisPlan = [contentList objectAtIndex:indexPath.row];
    
    if (showWhich == SHOWWHICH_FRIENDS){
        static NSString *CellIdentifier = @"friendCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    } else {
        static NSString *CellIdentifier = @"traineeCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    [self fillCellView:cell withPlanRunHistory:thisPlan];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self cellSelectAction:[tableView cellForRowAtIndexPath:indexPath]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<contentList.count)
        return 60;
    return 44;
}

@end
