//
//  RORTrainingHistoryViewController.h
//  Cyberace
//
//  Created by Bjorn on 13-12-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORPageViewController.h"
#import "RORPlanService.h"

@interface RORTrainingHistoryViewController : RORPageViewController{
    NSMutableArray *contentList;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
