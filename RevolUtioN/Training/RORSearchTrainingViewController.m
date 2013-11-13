//
//  RORSearchTrainingViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-11-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORSearchTrainingViewController.h"
#import "FTAnimation.h"

@interface RORSearchTrainingViewController ()

@end

@implementation RORSearchTrainingViewController

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
    self.backButton.alpha = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)expandAction:(id)sender {
    CGRect f = self.view.frame;
    
    if (f.origin.y < 0) {
        searchViewTop = f.origin.y;
        [self.view moveUp:0.5 length:-searchViewTop delegate:self];
        self.view.frame = CGRectMake(f.origin.x, 0, f.size.width, f.size.height);
    } else {
        [self.view moveUp:0.5 length:searchViewTop delegate:self];
        self.view.frame = CGRectMake(f.origin.x, searchViewTop, f.size.width, f.size.height);
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.row == 0){
        static NSString *CellIdentifier = @"simpleTrainingCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    } else{
        static NSString *CellIdentifier = @"advTrainingCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    return cell;
}
@end
