//
//  RORUserInfoViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-20.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORUserInfoBasicViewController.h"
#import "RORUserRunHistoryViewController.h"
#import "RORUserDoneMissionsViewController.h"
#import "RORHistoryViewController.h"
#import "RORViewController.h"


@interface RORUserInfoViewController : RORViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *contentViews;
@property (strong, nonatomic) RORUserInfoBasicViewController *userInfoBasicView;
@property (strong, nonatomic) RORUserRunHistoryViewController *userInfoRunHistoryView;
@property (strong, nonatomic) RORUserDoneMissionsViewController *userInfoDoneMissionsView;
@property (copy, nonatomic) NSDictionary *selection;
@property (copy, nonatomic) NSString *userName;
@property (strong, nonatomic) NSNumber *userId;
@property (weak, nonatomic) id delegate;

@end
