//
//  RORSearchTrainingViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-11-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORSearchTrainingViewController.h"
#import "FTAnimation.h"
#import "RORBookletViewController.h"

@interface RORSearchTrainingViewController ()

@end

@implementation RORSearchTrainingViewController
@synthesize delegate, expanded;

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
    expanded = NO;
    isTableEmpty = YES;
    currentPages = 0;
    noMoreData = NO;
    searching = 0;
    planNext = [RORPlanService fetchUserRunningPlanHistory];
    [Animations roundedCorners:self.tableView];
    
    contentList = [[NSMutableArray alloc]init];
    [self loadTableViewData:currentPages++];
}

-(void)viewWillAppear:(BOOL)animated{
    collectList = [RORPlanService fetchPlanCollect:[RORUserUtils getUserId]];
    [self.tableView reloadData];
}

-(void)reloadTableViewAction{
    collectList = [RORPlanService fetchPlanCollect:[RORUserUtils getUserId]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)expandAction:(id)sender {
    CGRect f = self.view.frame;
    
    if (!expanded) {
        expanded = YES;
        searchViewTop = f.origin.y;
        [self.view moveUp:0.5 length:-searchViewTop delegate:self];
        self.view.frame = CGRectMake(f.origin.x, 0, f.size.width, f.size.height);
        [self.expandButton setTitle:@"收起" forState:UIControlStateNormal];
        [self reloadTableViewAction];
    } else {
        expanded = NO;
        [self.view moveUp:0.5 length:searchViewTop delegate:self];
        self.view.frame = CGRectMake(f.origin.x, searchViewTop, f.size.width, f.size.height);
        [self.expandButton setTitle:@"添加" forState:UIControlStateNormal];
    }
}

-(BOOL)loadTableViewData:(NSInteger)page{
    if (noMoreData)
        return NO;
    
    int count = contentList.count;
    [self startIndicator:self];
    NSArray *array = [RORPlanService getTopPlansList:[NSNumber numberWithInteger:page]];
    [contentList addObjectsFromArray:array];
    [self endIndicator:self];
    if (contentList.count-count<PLAN_PAGE_SIZE){
        noMoreData = YES;
    }
    [self.tableView reloadData];
    return !noMoreData;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setPlan:)]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Plan *planNoDetail = (Plan *)[contentList objectAtIndex:indexPath.row];
        Plan *plan = [RORPlanService syncPlan:planNoDetail.planId];
        NSLog(@"%d", indexPath.row);
        [destination setValue:plan forKey:@"plan"];
    }
}

- (IBAction)prepare4SearchAction:(id)sender {
//    [self.searchTextField popUp:0.5 delegate:self targetPoint:self.searchTextField.center];
    [Animations frameAndShadow:self.searchTextFieldBg];
}

- (IBAction)doSearchAction:(id)sender {
//    [self.searchTextField popDown:0.5 delegate:self targetPoint:self.searchTextField.center];
    [self hideKeyboard:sender];
    
    UITextField *textField = (UITextField *)sender;
    NSNumber *planId =[RORDBCommon getNumberFromId:textField.text];
    if (!planId){
        textField.text = @"";
        if (searching)
            contentList = backupContentList;
        searching = NO;
        [self.tableView reloadData];
    } else {
        Plan *resultPlan = [RORPlanService fetchPlan:planId];
        if (!resultPlan){
            [self sendAlart:@"没找到这个训练！"];
            if (searching)
                contentList = backupContentList;
            searching = NO;
            [self.tableView reloadData];
            return;
        }
        if (!searching)
            backupContentList = contentList;
        contentList = [NSMutableArray arrayWithObjects:resultPlan, nil];
        searching = YES;
        [self.tableView reloadData];
    }
}

- (IBAction)hideKeyboard:(id)sender {
    [self.searchTextField resignFirstResponder];
    [Animations removeFrameAndShadow:self.searchTextFieldBg];
}

-(BOOL)isCollectAvailable:(Plan *)plan{
    for (Plan *itPlan in collectList)
        if (itPlan.planId.integerValue == plan.planId.integerValue)
            return NO;
    return YES;
}

-(void)operateAction:(Plan *)plan{
    if ([RORUserUtils getUserId].integerValue>0)
        [RORPlanService startNewPlan:plan.planId];
    else
        [self sendAlart:@"请先登录"];
}

-(void)collectAction:(Plan *)plan{
    if ([RORUserUtils getUserId].integerValue>0){
        [RORPlanService collectPlan:plan];
        if ([delegate respondsToSelector:@selector(reloadTableViewAction:)]){
            [delegate reloadTableViewAction:self];
        }
        [self.tableView reloadData];
    } else
        [self sendAlart:@"请先登录"];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (searching)
        return contentList.count;
    return contentList.count +1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.row == contentList.count) {
        static NSString *CellIdentifier = @"moreCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
        titleLabel.text = @"更多...";
        return cell;
    }
    
    Plan *thisPlan = [contentList objectAtIndex:indexPath.row];
    NSNumber *planType = thisPlan.planType;
    

    if (planType.integerValue == PlanTypeEasy){
        static NSString *CellIdentifier = @"simpleTrainingCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    } else if (planType.integerValue == PlanTypeComplex){
        static NSString *CellIdentifier = @"advTrainingCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    UILabel *timesLabel = (UILabel *)[cell viewWithTag:CELLTAG_TIMES];
    timesLabel.text = [NSString stringWithFormat:@"共%@次训练",thisPlan.totalMissions];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:CELLTAG_TITLE];
    titleLabel.text = thisPlan.planName;
    UIView *note = (UIView *)[cell viewWithTag:102];
    BOOL showNote = [self isCollectAvailable:thisPlan];
    note.alpha = showNote;
    
    UIImageView *certified = (UIImageView *)[cell viewWithTag:105];
    certified.alpha = thisPlan.sharedPlan.integerValue == SharedPlanSystem;
    UILabel *planIdLabel = (UILabel *)[cell viewWithTag:101];
    planIdLabel.text = [NSString stringWithFormat:@"编号：%@", thisPlan.planId];
    
//    if (showNote)
//        note.alpha = 1;
//    else
//        note.alpha = 0;

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == contentList.count){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
        if (![self loadTableViewData:currentPages++]){
            titleLabel.text = @"目前只有这么多";
        } else {
            titleLabel.text = @"更多...";
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<contentList.count)
        return 77;
    return 50;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (planNext) {
        if (indexPath.row >= contentList.count)
            return NO;
        else {
            UIView *note = [cell viewWithTag:102];
            return (int)note.alpha;
        }
    }
    return YES;
}

//更改删除按钮
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (planNext)
        return @"收藏";
    return @"执行";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Plan *plan = [contentList objectAtIndex:indexPath.row];

    if (planNext){
        [self collectAction:plan];
        [self reloadTableViewAction];
//        [self.tableView reloadData];
    } else {
        [self operateAction:plan];
        [self reloadTableViewAction];
//        [self.tableView reloadData];
    }
}
@end
