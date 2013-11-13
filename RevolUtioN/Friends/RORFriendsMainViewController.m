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

@end
