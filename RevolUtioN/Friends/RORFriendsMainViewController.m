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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)expandAction:(id)sender {
    CGRect f = self.searchFriendView.frame;
    
    if (f.origin.y < 0) {
        searchViewTop = f.origin.y;
        [self.searchFriendView moveUp:0.5 length:-searchViewTop delegate:self];
        self.searchFriendView.frame = CGRectMake(f.origin.x, 0, f.size.width, f.size.height);
    } else {
        [self.searchFriendView moveUp:0.5 length:searchViewTop delegate:self];
        self.searchFriendView.frame = CGRectMake(f.origin.x, searchViewTop, f.size.width, f.size.height);
    }
}

- (IBAction)hideKeyboard:(id)sender {
    [self.searchTextField resignFirstResponder];
}

- (IBAction)doSearchAction:(id)sender {
    userInfo = [RORUserServices syncUserInfoById:[RORUtils removeEggache:self.searchTextField.text]];
    [self showUserInfo];
    [self.searchTextField resignFirstResponder];
}

-(void)refreshAddButton{
    if (userInfo.userId.integerValue == [RORUserUtils getUserId].integerValue){
        self.addButton.enabled = 0;
        return;
    }
    
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

@end
