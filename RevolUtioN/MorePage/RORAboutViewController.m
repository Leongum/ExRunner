//
//  RORAboutViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-9-29.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORAboutViewController.h"
#import "RORSystemService.h"

@interface RORAboutViewController ()

@end

@implementation RORAboutViewController

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

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = nil;
    UITableViewCell *cell = nil;

    switch (indexPath.row) {
        case 0:
        {
            identifier = @"versionCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            Version_Control *version = [RORSystemService syncVersion:@"ios"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"v %@.%@", version.version, version.subVersion];
            [RORUtils setFontFamily:CHN_PRINT_FONT forView:cell andSubViews:YES];
            [RORUtils setFontFamily:ENG_WRITTEN_FONT forView:cell.detailTextLabel andSubViews:YES];
            break;
        }
        case 1:
        {
            identifier = @"siteCell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            [RORUtils setFontFamily:CHN_PRINT_FONT forView:cell andSubViews:YES];
            [RORUtils setFontFamily:ENG_WRITTEN_FONT forView:cell.detailTextLabel andSubViews:NO];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.cyberace.cc"]];
    }
}

@end
