//
//  RORChallengeViewController.h
//  RevolUtioN
//
//  Created by Bjorn on 13-8-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "RORBottomPopSubview.h"
#import "Mission.h"

@interface RORChallengeViewController : RORViewController{
    Mission *selectedChallenge;
}

@property (strong, nonatomic) IBOutlet RORBottomPopSubview *coverView;
@property (strong, nonatomic) NSArray *contentList;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIControl *levelRequirementTable;
@end
