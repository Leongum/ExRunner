//
//  RORBookletViewController.h
//  Cyberace
//
//  Created by Bjorn on 13-11-5.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "RORSearchTrainingViewController.h"

@interface RORBookletViewController : RORViewController{
    RORSearchTrainingViewController *searchViewController;
    BOOL isEditing;
}

@property (strong, nonatomic) UIView *searchTrainingView;
@property (strong, nonatomic) IBOutlet UIButton *editButton;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
