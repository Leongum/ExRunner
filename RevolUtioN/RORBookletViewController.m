
//
//  RORBookletViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-11-5.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORBookletViewController.h"
#import "Animations.h"
#import "FTAnimation.h"

@interface RORBookletViewController ()

@end

@implementation RORBookletViewController

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
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TrainingStoryboard" bundle:[NSBundle mainBundle]];
    searchViewController =  [storyboard instantiateViewControllerWithIdentifier:@"searchViewController"];
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    frame.origin.y = 55-frame.size.height;
    searchViewController.view.frame = frame;
    
    [self addChildViewController:searchViewController];
    [self.view addSubview:searchViewController.view];
    [searchViewController didMoveToParentViewController:self];
    self.searchTrainingView = searchViewController.view;
    
    [self.view bringSubviewToFront:self.backButton];
    [self.view bringSubviewToFront:self.editButton];
    
    contentList = [RORPlanService fetchPlanCollect:[RORUserUtils getUserId]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editButtonAction:(id)sender {
    if (isEditing){
        isEditing = NO;
        [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    } else {
        isEditing = YES;
        [self.editButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.row == 0){
        static NSString *CellIdentifier = @"1Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    } else if (indexPath.row == 1){
        static NSString *CellIdentifier = @"2Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    } else{
        static NSString *CellIdentifier = @"3Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    UIButton *deleteButton = (UIButton*)[cell viewWithTag:100];
    deleteButton.alpha = isEditing;
    
    return cell;
}

@end
