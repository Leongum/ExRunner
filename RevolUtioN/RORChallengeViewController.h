//
//  RORChallengeViewController.h
//  RevolUtioN
//
//  Created by Bjorn on 13-8-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "RORBottomPopSubview.h"

@interface RORChallengeViewController : RORViewController

@property (strong, nonatomic) IBOutlet RORBottomPopSubview *coverView;
@property (strong, nonatomic) NSMutableArray *contentList;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
