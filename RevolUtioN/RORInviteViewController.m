//
//  RORInviteViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORInviteViewController.h"

@interface RORInviteViewController ()

@end

@implementation RORInviteViewController
@synthesize locationTextFieldView;
@synthesize psTextFieldView;
@synthesize tableView;

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
//    UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
//    [tableView addGestureRecognizer:t];
}

-(void) singleTap:(UITapGestureRecognizer*) tap {
    if (tap.view != locationTextFieldView)
        [locationTextFieldView resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLocationTextFieldView:nil];
    [self setTableView:nil];
    [self setPsTextFieldView:nil];
    [self setDatetimeLabel:nil];
    [self setMissionLabel:nil];
    [super viewDidUnload];
}
- (IBAction)editEndAction:(id)sender {
    [locationTextFieldView resignFirstResponder];
    [psTextFieldView resignFirstResponder];
}

- (IBAction)tapOthersAction:(id)sender {
    [locationTextFieldView resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
//    if ([destination respondsToSelector:@selector(setSelection:)]){
//        NSIndexPath *indexPath = [tableView indexPathForCell:sender];
////        id object = [people objectAtIndex:indexPath.row];
////        NSDictionary *selection = [NSDictionary dictionaryWithObjectsAndKeys: indexPath, @"indexPath",object, @"object", nil];
////        [destination setValue:selection forKey:@"selection"];
////        NSString *name = [[self.people objectAtIndex:indexPath.row] objectForKey:@"name"];
////        [destination setValue:name forKey:@"name"];
//    }
}
@end
