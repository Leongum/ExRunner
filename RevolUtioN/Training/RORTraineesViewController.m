//
//  RORTraineesViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-11-5.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORTraineesViewController.h"
#import "FTAnimation.h"
#import "Animations.h"

#define FRAME_OF_TABLEVIEWTRAINEE CGRectMake(20, 253, 280, 200)
#define FRAME_OF_TABLEVIEWFRIENDS CGRectMake(20, 193, 280, 200)
#define ROWS 10

@interface RORTraineesViewController ()

@end

@implementation RORTraineesViewController

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
    [Animations frameAndShadow:self.partnerView];
    
    tableViewHeight = 4 * 44;
    
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, tableViewHeight);

    self.tableView.alpha = 0;
    traineeBtnInitY = self.showTraineesButton.center.y;
    tableViewInitY = self.tableView.center.y;
    
    tableViewPathLength = traineeBtnInitY - self.showFriendsButton.center.y;
    traineeBtnPathLength = self.tableView.frame.size.height;

}

-(void)viewDidAppear:(BOOL)animated{
//    self.tableView.contentSize = CGSizeMake(0, tableViewHeight);
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:ROWS inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showTraineesAction:(id)sender {
    double duration = 0.5;
    
//    self.tableView.frame.size.height/2 + self.showTraineesButton.frame.size.height/2 + 
    UIButton *btn = (UIButton *)sender;
//    if (self.tableView.alpha>0) {
//        [self.tableView fold:duration delegate:self startSelector:nil stopSelector:@selector(hideTableView)];
//    }
    self.tableView.alpha = 0;
    if (btn == self.showFriendsButton){
        if (self.showTraineesButton.center.y == traineeBtnInitY){
            [Animations moveDown:self.showTraineesButton andAnimationDuration:duration/2 andWait:NO andLength:traineeBtnPathLength];
        }
        if (self.tableView.center.y==tableViewInitY){
            [Animations moveUp:self.tableView andAnimationDuration:0 andWait:NO andLength:tableViewPathLength];
        }
    } else{
        if (!(self.showTraineesButton.center.y == traineeBtnInitY)){
            [Animations moveUp:self.showTraineesButton andAnimationDuration:duration andWait:YES andLength:traineeBtnPathLength];
        }
        if (!(self.tableView.center.y==tableViewInitY)){
            [Animations moveDown:self.tableView andAnimationDuration:0 andWait:NO andLength:tableViewPathLength];
        }
    }
    
    [self.tableView expand:duration delegate:self startSelector:@selector(showTableView) stopSelector:nil];

    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:ROWS inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

-(void)showTableView{
    self.tableView.alpha = 1;
}

-(void)hideTableView{
    self.tableView.alpha = 0;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return ROWS+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.row == 0){
        static NSString *CellIdentifier = @"refreshCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    } else {
        static NSString *CellIdentifier = @"traineeCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UILabel *label = (UILabel*)[cell viewWithTag:100];
        label.text = [NSString stringWithFormat:@"%d", indexPath.row];
    }
    
    return cell;
}

@end
