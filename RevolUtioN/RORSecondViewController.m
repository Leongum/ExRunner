//
//  RORSecondViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-4-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORSecondViewController.h"
#import "RORAppDelegate.h"
#import "RORUserUtils.h"
#import "RORPages.h"

@interface RORSecondViewController ()

@end

@implementation RORSecondViewController
@synthesize people, invitation;
@synthesize addFriendButton;
@synthesize tableView, coverView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //if ([RORUtils hasLoggedIn]){
        coverView.alpha = 0;
        self.people = [[NSMutableArray alloc] init];
        [self loadFriendsFromDatabase];
        NSDictionary *row1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"AdoubleZ", @"name", @"9月1号 20:00", @"date", nil];
        self.invitation = [[NSMutableArray alloc] initWithObjects:row1, nil];
        addFriendButton.enabled = YES;
//    } else {
//        addFriendButton.enabled = NO;
//        coverView.alpha = 1;
//    }
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self viewDidLoad];
    [tableView reloadData];
}

- (void)loadFriendsFromDatabase{
    NSError *error = nil;
    NSMutableDictionary *userDict = [RORUserUtils getUserInfoPList];
    self.userName = [userDict valueForKey:@"nickName"];
    self.userId = [userDict valueForKey:@"userId"];
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSEntityDescription *friendEntity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:friendEntity];
    NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchObject) {
        NSLog(@"%@", info);
        NSString *name = (NSString *) [info valueForKey:@"nickName"];
        if ([name isEqualToString:self.userName])
            continue;
        NSDictionary *row = [[NSDictionary alloc] initWithObjectsAndKeys:[info valueForKey:@"nickName"], @"nickName", [info valueForKey:@"sex"], @"sex", [info valueForKey:@"userId"], @"userId",nil];
        [people addObject:row];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setCoverView:nil];
    [self setAddFriendButton:nil];
    [self setInvitation:nil];
    [self setPeople:nil];
    [self setUserId:nil];
    [self setUserName:nil];
    [self setCoverView:nil];
    
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setSelection:)]){
        NSIndexPath *indexPath = [tableView indexPathForCell:sender];
        switch (indexPath.section) {
            case 0:
                break;
            case 1:
                break;
            case 2:
                break;
            case 3:
            {
                NSDictionary *person = [self.people objectAtIndex:indexPath.row];
                [destination setValue:[person valueForKey:@"nickName"] forKey:@"userName"];
                [destination setValue:[person valueForKey:@"userId"] forKey:@"userId"];
                break;
            }
            default:
                break;
        }
//        id object = [people objectAtIndex:indexPath.row];
//        NSDictionary *selection = [NSDictionary dictionaryWithObjectsAndKeys: indexPath, @"indexPath",object, @"object", nil];
//        [destination setValue:selection forKey:@"selection"];
//        NSString *name = [[self.people objectAtIndex:indexPath.row] objectForKey:@"name"];
//        [destination setValue:name forKey:@"name"];
    }
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [invitation count];
        case 1:
        case 2:
            return 0;
        case 3:
            return [people count];
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = nil;
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
        {
            NSDictionary *invite = [invitation objectAtIndex:indexPath.row];
            identifier = @"planCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel *nameLabel = (UILabel*)[cell viewWithTag:rNameLabelTag];
            nameLabel.text = [invite objectForKey:@"name"];
            UILabel *dateLabel = (UILabel*)[cell viewWithTag:rSubLabelTag];
            dateLabel.text = [invite objectForKey:@"date"];
        }
            break;
        case 1:
        case 2:
            break;
        case 3:
        {
            NSDictionary *person = [self.people objectAtIndex:indexPath.row];
            identifier = @"onlineCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            UILabel *nameLabel = (UILabel*)[cell viewWithTag:rNameLabelTag];
            nameLabel.text = [person objectForKey:@"nickName"];
            UILabel *subLabel = (UILabel*)[cell viewWithTag:rSubLabelTag];
            subLabel.text = [person valueForKey:@"sex"];
            
        }
            break;
        default:
            break;
    }
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"计划中";
        case 1:
            return @"已收到的邀请";
        case 2:
            return @"已发出的邀请";
        case 3:
            return @"好友列表";
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section>0) return;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"%d", indexPath.row);
        [invitation removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
    }
}
@end
