//
//  RORLoginCheckViewController.m
//  RevolUtioN
//
//  Created by leon on 13-8-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORLoginCheckViewController.h"

@interface RORLoginCheckViewController ()

@end

@implementation RORLoginCheckViewController

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

- (IBAction)sinaWeiboLogin:(id)sender {
    [RORShareService authLoginFromSNS:ShareTypeSinaWeibo];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tencentWeiboLogin:(id)sender {
    [RORShareService authLoginFromSNS:ShareTypeTencentWeibo];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)qqAccountLogin:(id)sender {
    [RORShareService authLoginFromSNS:ShareTypeQQSpace];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)renrenAccountLogin:(id)sender {
    [RORShareService authLoginFromSNS:ShareTypeRenren];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
