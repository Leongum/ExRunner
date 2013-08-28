//
//  RORMissionDetailViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-20.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORMissionDetailViewController.h"
#import "RORUserUtils.h"

@interface RORMissionDetailViewController ()

@end

@implementation RORMissionDetailViewController
@synthesize delegate;

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

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (IBAction)discardAction:(id)sender {
    NSMutableDictionary *userDict = [RORUserUtils getUserInfoPList];
    [userDict setValue:nil forKey:@"periodic"];
    [RORUserUtils writeToUserInfoPList:userDict];
    [delegate viewDidLoad];

    [self.navigationController popViewControllerAnimated:YES];
}
@end
