//
//  RORMoreViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORMoreViewController.h"
#import "User.h"
#import "RORAppDelegate.h"
#import "RORPublicMethods.h"
#import "RORSettings.h"

@interface RORMoreViewController ()

@end

@implementation RORMoreViewController
@synthesize context;
@synthesize cityName;
@synthesize cityRow;
@synthesize cityCode;
@synthesize provRow;
@synthesize moreTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self loadAll];
//    cityName = cityName;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
}

- (void)viewDidUnload {
    [self saveAll];
    [self setMoreTableView:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}

- (void)loadAll {
    NSMutableDictionary *data = [RORSettings getInstance];
    NSMutableDictionary *location = [data valueForKey:@"location"];
    cityName = [location valueForKey:@"name"];
}

- (void)saveAll {
    NSMutableDictionary *data = [RORSettings getInstance];
    NSMutableDictionary *location = [data valueForKey:@"location"];
    [location setValue:cityName forKey:@"name"];
    [location setValue:cityCode forKey:@"code"];
    [location setValue:cityRow forKey:@"cityRow"];
    [location setValue:provRow forKey:@"provRow"];
    [RORSettings setValue:location forKey:@"location"];
}
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = nil;
    UITableViewCell *cell = nil;

    switch (indexPath.row) {
        case 0:
        {
            identifier = @"accountCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel *label = (UILabel*)[cell viewWithTag:1];
            label.text = [RORPublicMethods hasLoggedIn];
            break;
        }
        case 1:
        {
            identifier = @"cityCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel *label = (UILabel*)[cell viewWithTag:1];
            label.text = cityName;
            break;
        }
    }
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    switch (section) {
//        case 0:
//            return @"计划中";
//        case 1:
//            return @"已收到的邀请";
//        case 2:
//            return @"已发出的邀请";
//        case 3:
//            return @"好友列表";
//        default:
//            break;
//    }
//    return nil;
//}



@end
