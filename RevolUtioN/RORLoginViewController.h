//
//  RORLoginViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User_Base.h"
#import "RORAppDelegate.h"
#import "RORUtils.h"
#import "RORPages.h"
#import "RORHttpResponse.h"
#import "RORUserServices.h"


@interface RORLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *switchButton;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sexButton;

@property (strong,nonatomic)NSManagedObjectContext *context;

@property (strong, nonatomic) UIViewController *delegate;

- (IBAction)loginAction:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)usernameDone:(id)sender;
- (IBAction)passwordDone:(id)sender;
- (IBAction)switchAction:(id)sender;
- (IBAction)visibilityOfPW:(id)sender;
- (IBAction)cancelAction:(id)sender;

@end
