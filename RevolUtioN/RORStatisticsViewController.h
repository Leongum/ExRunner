//
//  RORStatisticsViewController.h
//  RevolUtioN
//
//  Created by Bjorn on 13-8-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORRunHistoryServices.h"
#import "RORPageViewController.h"

@interface RORStatisticsViewController : RORPageViewController{
    double totalDistance, avgSpeed, totalCalorie;
}
@property (strong, nonatomic) NSMutableArray *filter;
@property (strong, nonatomic) IBOutlet UILabel *totalDistanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalSpeedLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalCalorieLabel;

@end
