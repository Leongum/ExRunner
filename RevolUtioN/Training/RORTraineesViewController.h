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
    int friendPageCount, traineePageCount;
    int tableCount;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *partnerView;
@property (strong, nonatomic) IBOutlet UIButton *showFriendsButton;
@property (strong, nonatomic) IBOutlet UIButton *showTraineesButton;
@property (strong, nonatomic) Plan_Next_mission *planNext;

@property (strong, nonatomic) IBOutlet UIView *friendBoard;
@end
