//
//  RORTrainingMainViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-11-4.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORTrainingMainViewController.h"

@interface RORTrainingMainViewController ()

@end

@implementation RORTrainingMainViewController

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
    bookletButtonFrame = self.bookletButton.frame;
    traineeButtonFrame = self.TraineeButton.frame;
    [self initLayout];
}

-(void)initLayout{
    if ([RORPlanService fetchUserRunningPlanHistory]){
        self.currentPlanView.alpha = 1;
        
        self.bookletButton.frame = bookletButtonFrame;
        self.TraineeButton.frame = traineeButtonFrame;
    } else {
        self.currentPlanView.alpha = 0;
        
        self.bookletButton.frame = self.currentPlanView.frame;
        self.TraineeButton.frame = CGRectMake(self.currentPlanView.frame.origin.x, self.TraineeButton.frame.origin.y, self.currentPlanView.frame.size.width, self.TraineeButton.frame.size.height);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.row == 0){
        static NSString *CellIdentifier = @"doneCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    } else if (indexPath.row == 1) {
        static NSString *CellIdentifier = @"thisCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    } else {
        static NSString *CellIdentifier = @"todoCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    return cell;
}
@end
