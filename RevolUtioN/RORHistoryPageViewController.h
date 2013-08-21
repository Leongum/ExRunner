//
//  RORHistoryPageViewController.h
//  RevolUtioN
//
//  Created by Bjorn on 13-8-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORHistoryViewController.h"
#import "RORStatisticsViewController.h"
#import "RORViewController.h"

@interface RORHistoryPageViewController : RORViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *contentViews;
@property (strong, nonatomic) RORStatisticsViewController *statisticsViewController;
@property (strong, nonatomic) RORHistoryViewController *listViewController;

@end
