//
//  RORMoreViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORViewController.h"


@interface RORMoreViewController : RORViewController
- (IBAction)logoutAction:(id)sender;
- (void)saveAll;

@property (strong, nonatomic) NSString *cityName;
@property (strong, nonatomic) NSString *cityCode;
@property (strong, nonatomic) NSNumber *provRow;
@property (strong, nonatomic) NSNumber *cityRow;
@property (strong,nonatomic)NSManagedObjectContext *context;

@property (strong, nonatomic) IBOutlet UITableView *moreTableView;

@end
