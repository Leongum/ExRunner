//
//  RORHistoryViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-6-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORHistoryViewController.h"
#import "RORAppDelegate.h"
#import "User_Running_History.h"
#import "RORUtils.h"
#import "RORHistoryPageViewController.h"
#import "RORRunHistoryServices.h"
#import "RORUserServices.h"

@interface RORHistoryViewController ()

@end

@implementation RORHistoryViewController
@synthesize runHistoryList, dateList, sortedDateList, syncButtonItem;

- (void)viewDidUnload{
    [self setSyncButtonItem:nil];
    [self setRunHistoryList:nil];
    [self setDateList:nil];
    [self setSortedDateList:nil];
    [self setTableView:nil];
    [self setNoHistoryMessageLabel:nil];
    [super viewDidUnload];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setRecord:)]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSLog(@"%d->%d", indexPath.section, indexPath.row);
        NSString *date_str = [sortedDateList objectAtIndex:indexPath.section];
        NSArray *records4DateList = [runHistoryList objectForKey:date_str];
        User_Running_History *record4Date = [records4DateList objectAtIndex:indexPath.row];
        [destination setValue:record4Date forKey:@"record"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //syncButtonItem.enabled = ([RORUtils hasLoggedIn]!=nil);
//    [self initTableData];
    [RORUtils setFontFamily:CHN_PRINT_FONT forView:self.noHistoryMessageLabel andSubViews:NO];
    self.noHistoryMessageLabel.text = NO_HISTORY;
    self.noHistoryMessageLabel.alpha = 0;
}

-(void)initTableData{
    NSMutableArray *filter = ((RORHistoryPageViewController*)[self parentViewController]).filter;
    
    runHistoryList = [[NSMutableDictionary alloc] init];
    dateList = [[NSMutableArray alloc] init];
    
//    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = delegate.managedObjectContext;
//    NSEntityDescription *historyEntity = [NSEntityDescription entityForName:@"User_Running_History" inManagedObjectContext:context];
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
//    [fetchRequest setEntity:historyEntity];
//    NSError *error = nil;
    NSArray *fetchObject = [RORRunHistoryServices fetchRunHistory];
    if (fetchObject>0){
        [self showContent];
        for (User_Running_History *historyObj in fetchObject) {
            NSNumber *missionType = (NSNumber *)[historyObj valueForKey:@"missionTypeId"];
            
            if (![filter containsObject:missionType]) {
                continue;
            }
            NSDate *date = [historyObj valueForKey:@"missionDate"];
            NSDateFormatter *formate = [[NSDateFormatter alloc] init];
            //    formate.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            [formate setDateFormat:@"yyyy-MM-dd"];
            //        [formate setTimeStyle:NSDateFormatterNoStyle];
            NSString *formatDateString = [formate stringFromDate:date];
            if (![dateList containsObject:formatDateString])
                [dateList addObject:formatDateString];
            NSMutableArray *record4Date = [runHistoryList objectForKey:formatDateString];
            if (record4Date == nil)
                record4Date = [[NSMutableArray alloc] init];
            [record4Date addObject:historyObj];
            [runHistoryList setObject:record4Date forKey:formatDateString];
        }
    } else {
        [self hideContent];
    }
    //    NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"string"
    //																   ascending:NO
    //																	selector:@selector(localizedCaseInsensitiveCompare:)] ;
	
    //	NSArray *descriptors = [NSArray arrayWithObject:dateDescriptor];
    //    [dateList sortUsingDescriptors:descriptors];
    sortedDateList = [dateList sortedArrayUsingComparator:^(NSString *str1, NSString *str2){
        return [str2 compare:str1];
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshTable];
}

-(void)refreshTable{
    
    [self initTableData];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showContent{
    self.tableView.alpha = 1;
    self.noHistoryMessageLabel.alpha = 0;
}

-(void)hideContent{
    self.tableView.alpha = 0;
    self.noHistoryMessageLabel.alpha = 1;
}

- (IBAction)syncAction:(id)sender {
    //sync runningHistory
    BOOL synced = [RORRunHistoryServices syncRunningHistories];
    BOOL updated = [RORRunHistoryServices uploadRunningHistories];
    [RORUserServices syncUserInfoById:[RORUserUtils getUserId]];
    if(synced && updated){
        [(RORViewController *)[self parentViewController] sendNotification:SYNC_DATA_SUCCESS];
    }
    else{
        [(RORViewController *)[self parentViewController] sendNotification:SYNC_DATA_FAIL];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return sortedDateList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *date_str = [sortedDateList objectAtIndex:section];
    NSArray *records4Date = [runHistoryList objectForKey:date_str];
    return records4Date.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (NSString *)[sortedDateList objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"plainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [RORUtils setFontFamily:ENG_WRITTEN_FONT forView:cell andSubViews:YES];
    
    NSString *date_str = [sortedDateList objectAtIndex:indexPath.section];
    NSArray *records4DateList = [runHistoryList objectForKey:date_str];
    User_Running_History *record4Date = [records4DateList objectAtIndex:indexPath.row];
    UILabel *distanceLabel = (UILabel *)[cell viewWithTag:DISTANCE];
    distanceLabel.text = [NSString stringWithFormat:@"%@",[RORUtils outputDistance:record4Date.distance.doubleValue]];    
    UILabel *durationLabel = (UILabel *)[cell viewWithTag:DURATION];
    durationLabel.text = [RORUtils transSecondToStandardFormat:[record4Date.duration integerValue]];
    UILabel *missionTypeLabel = (UILabel *)[cell viewWithTag:MISSIONTYPE];
    missionTypeLabel.text = [NSString stringWithFormat:@"%@",record4Date.valid];
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *result = nil;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
    label.text = (NSString *)[sortedDateList objectAtIndex:section];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = UITextAlignmentRight;
    label.textColor = [UIColor darkGrayColor];
    label.backgroundColor = [UIColor clearColor];
    [RORUtils setFontFamily:ENG_WRITTEN_FONT forView:label andSubViews:YES];
//    //将UILabel向右移动10个点，沿y轴向下移动5个点
//    label.frame = CGRectMake(label.frame.origin.x + 10.0f,5.0f,label.frame.size.width, label.frame.size.height);
    //container的宽度比UILabel多出是个像素这些像素用于缩进
//    CGRect resultFrame = CGRectMake(0.0f, 0.0f,
//                                    label.frame.size.height,
//                                    label.frame.size.width + 10.0f);
    result = [[UIView alloc] initWithFrame:label.frame];
    [result addSubview:label];
    return result; 
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
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section>0) return;
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
////        NSLog(@"%d", indexPath.row);
//        NSString *date_str = [dateList objectAtIndex:indexPath.section];
//        NSMutableArray *records4DateList = [runHistoryList objectForKey:date_str];
//        [records4DateList removeObjectAtIndex:indexPath.row];
//        [runHistoryList setObject:records4DateList forKey:date_str];
//        
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
//    }
//}


@end
