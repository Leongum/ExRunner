//
//  RORTraineesViewController.h
//  Cyberace
//
//  Created by Bjorn on 13-11-5.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORViewController.h"

@interface RORTraineesViewController : RORViewController{
    double traineeBtnInitY, tableViewInitY;
    double tableViewPathLength;
    double traineeBtnPathLength;
    
    double tableViewHeight;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *partnerView;
@property (strong, nonatomic) IBOutlet UIButton *showFriendsButton;
@property (strong, nonatomic) IBOutlet UIButton *showTraineesButton;

@property (strong, nonatomic) IBOutlet UIView *friendBoard;
@end
