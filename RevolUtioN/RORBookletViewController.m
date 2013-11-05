
//
//  RORBookletViewController.m
//  Cyberace
//
//  Created by Bjorn on 13-11-5.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORBookletViewController.h"
#import "Animations.h"
#import "FTAnimation.h"

@interface RORBookletViewController ()

@end

@implementation RORBookletViewController

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
    CGRect f = self.searchTrainingView.frame;

    if (f.origin.y < 0) {
        searchViewTop = f.origin.y;
        [self.searchTrainingView moveUp:0.5 length:-searchViewTop delegate:self];
        self.searchTrainingView.frame = CGRectMake(f.origin.x, 0, f.size.width, f.size.height);
    } else {
        [self.searchTrainingView moveUp:0.5 length:searchViewTop delegate:self];
        self.searchTrainingView.frame = CGRectMake(f.origin.x, searchViewTop, f.size.width, f.size.height);
    }
}

@end
