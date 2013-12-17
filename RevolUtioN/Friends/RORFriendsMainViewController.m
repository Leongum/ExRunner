//
//  RORFriendsMainViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-11-6.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORFriendsMainViewController.h"
#import "FTAnimation.h"

@interface RORFriendsMainViewController ()

@end

@implementation RORFriendsMainViewController

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
    noMoreData = NO;
    pageCount = 0;
    [RORUserServices syncFollowersDetails:[RORUserUtils getUserId] withPageNo:[NSNumber numberWithInt:pageCount]];
    contentList = [[NSMutableArray alloc]init];
    [contentList addObjectsFromArray:[RORUserServices fetchFollowersDetails:[RORUserUtils getUserId] withPageNo:[NSNumber numberWithInt:pageCount++]]];
    latestPage = contentList;
    self.addButton.enabled = 0;
    
    [Animations frameAndShadow:self.searchFriendView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self initSearchField];
}

- (IBAction)editingDidBegin:(id)sender {
//    [Animations frameAndShadow:self.searchTextField];
    self.searchTextField.text = @"";
}

-(void)viewWillDisAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableView setEditing:NO];
}

-(void)initSearchField{
    self.searchTextField.text = @"";
    self.searchResultUserNameLabel.text = @"";
    self.searchResultUserLvLabel.text = @"";
    self.addButton.alpha = 0;
}

- (IBAction)expandAction:(id)sender {
    CGRect f = self.searchFriendView.frame;
    
    if (f.origin.y < 0) {
        searchViewTop = f.origin.y;
        [self.searchFriendView moveUp:0.5 length:-searchViewTop delegate:self];
        self.searchFriendView.frame = CGRectMake(f.origin.x, 0, f.size.width, f.size.height);
        [self initSearchField];
        [self.searchTextField becomeFirstResponder];

    } else {
        [self.searchFriendView moveUp:0.5 length:searchViewTop delegate:self];
        self.searchFriendView.frame = CGRectMake(f.origin.x, searchViewTop, f.size.width, f.size.height);
        [self.searchTextField resignFirstResponder];
    }
}

- (IBAction)hideKeyboard:(id)sender {
    [self.searchTextField resignFirstResponder];
    [Animations removeFrameAndShadow:self.searchTextField];
}

- (IBAction)doSearchAction:(id)sender {
    userInfo = [RORUserServices syncUserInfoById:[RORUtils removeEggache:self.searchTextField.text]];
    if (userInfo){
        [self showUserInfo];
        [self refreshAddButton];
    } else {
        [self sendAlart:@"无此用户"];
    }
    [self.searchTextField resignFirstResponder];
    [Animations removeFrameAndShadow:self.searchTextField];
}

-(void)refreshAddButton{
    self.addButton.alpha = 1;
    if (userInfo.userId.integerValue == [RORUserUtils getUserId].integerValue ){
        [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
        self.addButton.enabled = 0;
        return;
    }
    Plan_User_Follow *userFollow = [RORPlanService fetchUserFollow:[RORUserUtils getUserId] withFollowerId:userInfo.userId];
    if (userFollow && userFollow.status.integerValue == FollowStatusFollowed){
        [self.addButton setTitle:@"已添加" forState:UIControlStateNormal];
        self.addButton.enabled = 0;
        return;
    }
    
    [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
    self.addButton.enabled = 1;
}

-(void)showUserInfo{
    self.searchResultUserNameLabel.text = userInfo.nickName;
    self.searchResultUserLvLabel.text = [NSString stringWithFormat:@"Lv.%d", userInfo.attributes.level.integerValue];
}

- (IBAction)addAction:(id)sender {
    Plan_User_Follow *userFollow = [Plan_User_Follow intiUnassociateEntity];
    userFollow.userId = [RORUserUtils getUserId];
    userFollow.followUserId = userInfo.userId;
    userFollow.status = [NSNumber numberWithInt:FollowStatusFollowed];
    [RORPlanService updateUserFollow:userFollow];
    self.addButton.enabled = 0;
    [self.tableViewContainer pop:0.5 delegate:self];
    [self reloadTableView];
}

-(void)reloadTableView{
    contentList = [[NSMutableArray alloc]init];
    for (int i=0; i<pageCount; i++){
         [contentList addObjectsFromArray:[RORUserServices fetchFollowersDetails:[RORUserUtils getUserId] withPageNo:[NSNumber numberWithInt:pageCount]]];
    }
    [self.tableView reloadData];
}

-(void)loadTableViewData:(NSInteger)page{
    if (noMoreData)
        return;
    
    int count = contentList.count;
    latestPage = [RORUserServices fetchFollowersDetails:[RORUserUtils getUserId] withPageNo:[NSNumber numberWithInt:page]];
    [contentList addObjectsFromArray:latestPage];
    if (contentList.count-count<FRIENDS_PAGE_SIZE){
        noMoreData = YES;
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
    
    User_Base *user = [contentList objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"userInfoCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *userNameLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *userLevelLabel = (UILabel *)[cell viewWithTag:101];
    userNameLabel.text = user.nickName;
    userLevelLabel.text = [NSString stringWithFormat:@"Lv.%d", user.attributes.level.integerValue];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == contentList.count){
        [self loadTableViewData:pageCount++];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<contentList.count)
        return 77;
    return 50;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//更改删除按钮
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    User_Base *user = [contentList objectAtIndex:indexPath.row];
    Plan_User_Follow *userFollow = [RORPlanService fetchUserFollow:[RORUserUtils getUserId] withFollowerId:user.userId];
    userFollow.userId = [RORUserUtils getUserId];
    userFollow.followUserId = user.userId;
    userFollow.status = [NSNumber numberWithInt:FollowStatusNotFollowed];
    [RORPlanService updateUserFollow:userFollow];
    [self.tableView pop:0.5 delegate:self];
    [self reloadTableView];
}

@end
