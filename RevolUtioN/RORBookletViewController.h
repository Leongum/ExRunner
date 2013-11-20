//
//  RORBookletViewController.h
//  Cyberace
//
//  Created by Bjorn on 13-11-5.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORTrainingViewController.h"
#import "RORSearchTrainingViewController.h"

@interface RORBookletViewController : RORTrainingViewController{
    RORSearchTrainingViewController *searchViewController;
    BOOL isEditing;
    NSArray *contentList;
}

@property (strong, nonatomic) UIView *searchTrainingView;
@property (strong, nonatomic) IBOutlet UIButton *editButton;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
