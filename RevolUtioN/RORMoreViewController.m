//
//  RORMoreViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORMoreViewController.h"
#import "User_Base.h"
#import "RORAppDelegate.h"
#import "RORUtils.h"
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
    if ([destination respondsToSelector:@selector(setSubLocalityName:)]){
        [destination setValue:cityName forKey:@"subLocalityName"];
    }
}

- (void)viewDidUnload {
    [self saveAll];
    [self setMoreTableView:nil];
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
    return 3;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = nil;
    UITableViewCell *cell = nil;

    switch (indexPath.row) {
        case 0:
        {
            identifier = @"accountCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            //UILabel *label = (UILabel*)[cell viewWithTag:1];
            //label.text = [RORUtils hasLoggedIn];
            break;
        }
        case 1:
        {
            identifier = @"bodyCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel *label = (UILabel*)[cell viewWithTag:1];
            label.text = @"身体参数";
            break;
        }
        case 2:
        {
            identifier = @"syncCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel *label = (UILabel*)[cell viewWithTag:1];
            label.text = @"即时同步";
            break;
        }
    }
    [RORUtils setFontFamily:@"FZKaTong-M19S" forView:cell andSubViews:YES];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
