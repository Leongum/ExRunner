//
//  RORSearchTrainingViewController.h
//  Cyberace
//
//  Created by Bjorn on 13-11-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORTrainingViewController.h"

#define CELLTAG_TITLE 100
#define CELLTAG_TIMES 101

@interface RORSearchTrainingViewController : RORTrainingViewController{
    double searchViewTop;
    BOOL expanded;
    BOOL isTableEmpty;
    NSInteger currentPages;
    NSMutableArray *contentList;
    BOOL noMoreData;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
