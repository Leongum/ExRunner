//
//  RORRecommendViewController.m
//  Cyberace
//
//  Created by Bjorn on 14-1-10.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "RORRecommendViewController.h"

@interface RORRecommendViewController ()

@end

@implementation RORRecommendViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"plainCell"];
    
    UIImageView *appIcon = (UIImageView *)[cell viewWithTag:100];
    UILabel *appNameLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *appDescriptionLabel = (UILabel *)[cell viewWithTag:102];
    
    
    
    return cell;
}

@end
