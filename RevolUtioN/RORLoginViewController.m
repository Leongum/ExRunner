//
//  RORLoginViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-24.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORLoginViewController.h"
#import "RORRunHistoryServices.h"
#import "RORShareService.h"
#import "RORNetWorkUtils.h"
#import <AGCommon/UIImage+Common.h>

@interface RORLoginViewController ()

@end

@implementation RORLoginViewController
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize nicknameTextField;
@synthesize switchButton;
@synthesize sexButton;
@synthesize context;
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
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:
                                        @"Icon/sns_icon_%d.png",
                                        ShareTypeRenren]
                            bundleName:@"Resource"];
    [self.btnRenRenLogin setBackgroundImage:img forState:UIControlStateNormal];
    img = [UIImage imageNamed:[NSString stringWithFormat:
                                        @"Icon/sns_icon_%d.png",
                                        ShareTypeSinaWeibo]
                            bundleName:@"Resource"];
    [self.btnSinaLogin setBackgroundImage:img forState:UIControlStateNormal];
    img = [UIImage imageNamed:[NSString stringWithFormat:
                                        @"Icon/sns_icon_%d.png",
                                        ShareTypeQQ]
                            bundleName:@"Resource"];
    [self.btnQQLogin setBackgroundImage:img forState:UIControlStateNormal];
    img = [UIImage imageNamed:[NSString stringWithFormat:
                                        @"Icon/sns_icon_%d.png",
                                        ShareTypeTencentWeibo]
                            bundleName:@"Resource"];
    [self.btnTencentLogin setBackgroundImage:img forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setDelegate:)]){
        [destination setValue:self forKey:@"delegate"];
    }
}

-(IBAction)nickNameTapped:(id)sender{
//    nicknameTextField.backgroundColor = [UIColor lightGrayColor];
    CGRect rx = [ UIScreen mainScreen ].applicationFrame;
    if (rx.size.height-nicknameTextField.frame.origin.y + nicknameTextField.frame.size.height<=260)
        [Animations moveUp:self.view andAnimationDuration:0.3 andWait:NO andLength:75];
}

//提交用户名密码之后的操作
- (IBAction)loginAction:(id)sender {
    if(![RORNetWorkUtils getIsConnetioned]){
        [self sendNotification:CONNECTION_ERROR];
        return;
    }
    if (![self isLegalInput]) return;
    if (switchButton.selectedSegmentIndex == 0){ //登录
        NSString *userName = usernameTextField.text;
        NSString *password = [RORUtils md5:passwordTextField.text];
        User_Base *user = [RORUserServices syncUserInfoByLogin:userName withUserPasswordL:password];
        
        if (user == nil){
            [self sendNotification:LOGIN_ERROR];
            return;
        }
        [RORRunHistoryServices syncRunningHistories];
    } else { //注册
        NSDictionary *regDict = [[NSDictionary alloc]initWithObjectsAndKeys:usernameTextField.text, @"userEmail",[RORUtils md5:passwordTextField.text], @"password", nicknameTextField.text, @"nickName", [sexButton selectedSegmentIndex]==0?@"男":@"女", @"sex", nil];
        User_Base *user = [RORUserServices registerUser:regDict];
        
        if (user != nil){
            [self sendNotification:REGISTER_SUCCESS];
            [self performSegueWithIdentifier:@"bodySetting" sender:self];
            return;
        } else {
            [self sendNotification:REGISTER_FAIL];
            return;
        }
    }
    passwordTextField.text = @"";
    nicknameTextField.text = @"";
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL) isLegalInput {
    if (switchButton.selectedSegmentIndex == 0){
        if ([usernameTextField.text isEqualToString:@""] ||
            [passwordTextField.text isEqualToString:@""]) {
            [self sendNotification:LOGIN_INPUT_CHECK];
            return NO;
        }
    } else {
        if ([usernameTextField.text isEqualToString:@""] ||
            [passwordTextField.text isEqualToString:@""] ||
            [nicknameTextField.text isEqualToString:@""]) {
            [self sendNotification:REGISTER_INPUT_CHECK];
            return NO;
        }
    }
    return YES;
}

- (IBAction)backgroundTap:(id)sender {
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [nicknameTextField resignFirstResponder];
    if (self.view.frame.origin.y<0)
        [Animations moveDown:self.view andAnimationDuration:0.3 andWait:NO andLength:75];
}

- (IBAction)usernameDone:(id)sender {
}

- (IBAction)passwordDone:(id)sender {
    [passwordTextField resignFirstResponder];
}

- (IBAction)switchAction:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.2];
    
    nicknameTextField.alpha = [sender selectedSegmentIndex];
    sexButton.alpha = [sender selectedSegmentIndex];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

- (IBAction)visibilityOfPW:(id)sender {
    UISwitch *button = (UISwitch *)sender;
    passwordTextField.secureTextEntry = button.isOn;
    [passwordTextField resignFirstResponder];
}

- (IBAction)cancelAction:(id)sender {
    [self dismissModalViewControllerAnimated:YES]; // for IOS 5+
}

- (IBAction)sinaWeiboLogin:(id)sender {
    [self authLoginFromSNS:ShareTypeSinaWeibo];
}

- (IBAction)tencentWeiboLogin:(id)sender {
    [self authLoginFromSNS:ShareTypeTencentWeibo];
}

- (IBAction)qqAccountLogin:(id)sender {
    [self authLoginFromSNS:ShareTypeQQSpace];
}

- (IBAction)renrenAccountLogin:(id)sender {
    [self authLoginFromSNS:ShareTypeRenren];
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    
    [self setBtnRenRenLogin:nil];
    [self setBtnQQLogin:nil];
    [self setBtnTencentLogin:nil];
    [self setBtnSinaLogin:nil];
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [self setSwitchButton:nil];
    [self setNicknameTextField:nil];
    [self setSexButton:nil];
    //[super viewDidUnload];
}

- (void)authLoginFromSNS:(ShareType) type{
    RORAppDelegate *appDelegate = (RORAppDelegate *)[UIApplication sharedApplication].delegate;
    
    //RORShareViewDelegate *shareViewDelegate = [[RORShareViewDelegate alloc] init];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:appDelegate.viewDelegate
                                               authManagerViewDelegate:nil];
    
    [authOptions setPowerByHidden:true];
    
    [ShareSDK getUserInfoWithType:type
                      authOptions:authOptions
                           result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
                               if (result)
                               {
                                   BOOL islogin = [RORShareService loginFromSNS:userInfo withSNSType: type];
                                   [RORUserUtils userInfoUpdateHandler:userInfo withSNSType: type];
                                   if(islogin){
                                       [RORRunHistoryServices syncRunningHistories];
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }
                                   else{
                                       [self performSegueWithIdentifier:@"bodySetting" sender:self];
                                   }
                               }
                               else
                               {
                                   [self sendNotification:error.errorDescription];
                               }
                           }];
}


@end
