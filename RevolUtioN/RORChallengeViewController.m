//
//  RORChallengeViewController.m
//  RevolUtioN
//
//  Created by Bjorn on 13-8-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORChallengeViewController.h"
#import "RORMissionServices.h"
#import "Animations.h"
#import "FTAnimation.h"
#import "RORChallengeLevelView.h"

#define CELL_TITLE_TAG 1
#define CELL_LEVEL_TAG 2

#define COVERVIEW_LABEL_TAG 1
#define COVERVIEW_BOARD_TAG 2
#define COVERVIEW_BUTTON_TAG 3
#define COVERVIEW_BG_TAG 4

#define LEVELTABLE_FRAME CGRectMake(25, 180, 270, 90)

@interface RORChallengeViewController ()

@end

@implementation RORChallengeViewController
@synthesize contentList;

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
    self.coverView.alpha =0;
    
    RORChallengeLevelView *levelTable = [[RORChallengeLevelView alloc]initWithFrame:LEVELTABLE_FRAME andNumberOfColumns:6];
    [levelTable setBackgroundColor:[UIColor colorWithRed:231 green:8 blue:53 alpha:1]];
    [self.coverView addSubview:levelTable];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadContentList];
    [self.tableView reloadData];
}

-(void)loadContentList{
    contentList = [RORMissionServices fetchMissionList:Challenge];
//    contentList = [[NSMutableArray alloc]init];
//    [contentList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"1 km", @"title", @"B", @"level", nil]];
//    [contentList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"2 km", @"title", @"A", @"level", nil]];
//    [contentList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"3 km", @"title", @"S", @"level", nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCoverView:nil];
    [self setTableView:nil];
    [self setLevelRequirementTable:nil];
    [super viewDidUnload];
}

- (IBAction)levelTableTap:(id)sender {
    [self hideCoverView];
}

-(IBAction)coverViewBgTap:(id)sender{
    [self hideCoverView];
}

-(void)hideCoverView{
    [Animations fadeOut:self.coverView andAnimationDuration:0.3 fromAlpha:1 andWait:NO];
    [Animations fadeIn:self.backButton andAnimationDuration:0.3 toAlpha:1 andWait:YES];
}

-(void)showCoverView{
    self.coverView.alpha = 1;
    [self.coverView popIn:0.4 delegate:nil];

//    [Animations fadeIn:self.coverView andAnimationDuration:0.3 toAlpha:1 andWait:NO];
    [Animations fadeOut:self.backButton andAnimationDuration:0.3 fromAlpha:1 andWait:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
    if ([destination respondsToSelector:@selector(setMissionType:)]){
        [destination setValue:[NSNumber numberWithInteger:Challenge] forKey:@"missionType"];
    }
    if ([destination respondsToSelector:@selector(setRunMission:)]){
        [destination setValue:selectedChallenge forKey:@"runMission"];
    }
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
    return contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"plainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Mission *challenge = (Mission *)[contentList objectAtIndex:indexPath.row];
    
    UILabel *titleLabel = (UILabel*)[cell viewWithTag:CELL_TITLE_TAG];
    titleLabel.text = challenge.missionName;
//    UILabel *levelLabel = (UILabel *)[cell viewWithTag:CELL_LEVEL_TAG];
//    levelLabel.text = [content valueForKey:@"level"];
    
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
    selectedChallenge = (Mission *)[contentList objectAtIndex:indexPath.row];
    
    UILabel *titleLabel = (UILabel*)[self.coverView viewWithTag:COVERVIEW_LABEL_TAG];
    titleLabel.text = selectedChallenge.missionName;
    
    [self showCoverView];
    
}
@end
