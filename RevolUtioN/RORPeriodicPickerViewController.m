//
//  RORPeriodicPickerViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORPeriodicPickerViewController.h"
#import "RORAppDelegate.h"
#import "RORUserUtils.h"
#import "Mission.h"
#import "RORConstant.h"

@interface RORPeriodicPickerViewController ()

@end

@implementation RORPeriodicPickerViewController
@synthesize periodicList, delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self loadContent];
}

- (void)loadContent{
    NSError *error = nil;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/missions/package",SERVICE_URL]]];
    //    将请求的url数据放到NSData对象中
    NSHTTPURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:nil];
    //    iOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    //    NSLog(@"%@", [response description]);
    NSInteger statCode = [urlResponse statusCode];

    if (statCode == 200){
        periodicList = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        //        NSLog(@"%@", [missionList description]);
    } else {
        NSLog(@"sync with host error: can't get mission package list. Status Code: %d", statCode);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)okAction:(id)sender {
    NSMutableDictionary *userDict = [RORUserUtils getUserInfoPList];
    [userDict setValue:self.startingMissionId forKey:@"periodic"];
    [RORUserUtils writeToUserInfoPList:userDict];
//    [delegate viewDidLoad];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return periodicList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"plainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *thisPackage = [periodicList objectAtIndex:indexPath.row];
    UILabel *nameLabel = (UILabel*)[tableView viewWithTag:1];
    UILabel *periodLabel = (UILabel*)[tableView viewWithTag:2];
    UITextView *descLabel = (UITextView*)[tableView viewWithTag:3];
    nameLabel.text = [thisPackage valueForKey:@"missionPackageName"];
    NSArray *list = [thisPackage valueForKey:@"missionPackageList"];
    periodLabel.text = [NSString stringWithFormat:@"%d个周期",list.count];
    descLabel.text = [thisPackage valueForKey:@"missionPackageDescription"];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    NSArray *list = [[periodicList objectAtIndex:indexPath.row] valueForKey:@"missionPackageList"];
    for (id obj in list){
        NSNumber *seq = [obj valueForKey:@"sequence"];
        if ([seq integerValue] == 1){
            NSNumber *num = [obj valueForKey:@"missionId"];
            self.startingMissionId = num;
            return;
        }
    }
}

- (void)viewDidUnload {

    [super viewDidUnload];
}

@end
