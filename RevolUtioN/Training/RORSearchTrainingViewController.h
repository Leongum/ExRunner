//
//  RORSearchTrainingViewController.h
//  Cyberace
//
//  Created by Bjorn on 13-11-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORTrainingViewController.h"
#import "RORTrainingMainViewController.h"

#define CELLTAG_TITLE 100
#define CELLTAG_TIMES 101

@interface RORSearchTrainingViewController : RORTrainingViewController{
    double searchViewTop;
    BOOL isTableEmpty;
    NSInteger currentPages;
    NSMutableArray *contentList;
    BOOL noMoreData;
    NSMutableArray *backupContentList;
    BOOL searching;
    
    NSArray *collectList;
    Plan_Next_mission *planNext;
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIImageView *searchTextFieldBg;
@property (strong, nonatomic) IBOutlet UIButton *expandButton;
@property (nonatomic) BOOL expanded;
@property (strong, nonatomic) IBOutlet UIImageView *fuzzyCoverView;

- (IBAction)expandAction:(id)sender;

@end
