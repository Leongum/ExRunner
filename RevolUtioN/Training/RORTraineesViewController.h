//
//  RORTraineesViewController.h
//  Cyberace
//
//  Created by Bjorn on 13-11-5.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORTrainingViewController.h"

#define SHOWWHICH_NONE 0
#define SHOWWHICH_FRIENDS 1
#define SHOWWHICH_TRAINEES 2

@interface RORTraineesViewController : RORTrainingViewController{
    double traineeBtnInitY, tableViewInitY;
    double tableViewPathLength;
    double traineeBtnPathLength;
    
    double tableViewHeight;
    int showWhich;
    
    NSMutableArray *friendList;
    NSMutableArray *traineeList;
    NSMutableArray *contentList;
    
    int friendPageCount, traineePageCount;
    int tableCount;
    
    UIImageView *popUpView;
    UITableViewCell *popUpCellView;
    CGPoint popUpFrom;
    
    Plan_Run_History *fixonPlanRunHistory;
}
@property (strong, nonatomic) IBOutlet UIView *tableViewContainerView;
@property (strong, nonatomic) IBOutlet UIImageView *tableViewBg;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *partnerView;
@property (strong, nonatomic) IBOutlet UIButton *showFriendsButton;
@property (strong, nonatomic) IBOutlet UIButton *showTraineesButton;
@property (strong, nonatomic) IBOutlet UIView *coverView;
@property (strong, nonatomic) IBOutlet UIView *friendBoard;
@property (strong, nonatomic) IBOutlet UIButton *removeFixonButton;

@property (strong, nonatomic) Plan_Next_mission *planNext;


@end
