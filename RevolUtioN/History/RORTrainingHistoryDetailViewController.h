//
//  RORTrainingHistoryDetailViewController.h
//  Cyberace
//
//  Created by Bjorn on 13-12-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORTrainingViewController.h"
#import "RORTrainingHistoryShareView.h"

@interface RORTrainingHistoryDetailViewController : RORTrainingViewController{
    NSMutableArray *contentList;
    Plan *thisPlan;
    
    double totleDistance;
    double totleDuration;
    double avgSpeed;
    
}

@property (strong, nonatomic) Plan_Run_History* thisHistory;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *trainingNameLabel;
@property (strong, nonatomic) IBOutlet UIView *view2Fill;
@property (strong, nonatomic) IBOutlet UIView *totle2Fill;


@end
