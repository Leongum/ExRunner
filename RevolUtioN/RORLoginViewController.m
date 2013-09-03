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

UIAlertView * registerAlert;

- (void) performDismiss
{
    [registerAlert dismissWithClickedButtonIndex:0 animated:YES];
    [self performSegueWithIdentifier:@"bodySetting" sender:self];
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

//提交用户名密码之后的操作
- (IBAction)loginAction:(id)sender {
    if(![RORNetWorkUtils getIsConnetioned]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设备尚未连接网络！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    if (![self isLegalInput]) return;
    if (switchButton.selectedSegmentIndex == 0){ //登录
        NSLog(@"userName: %@ password:%@",usernameTextField.text,passwordTextField.text);
        NSString *userName = usernameTextField.text;
        NSString *password = [RORUtils md5:passwordTextField.text];
        User_Base *user = [RORUserServices syncUserInfoByLogin:userName withUserPasswordL:password];
        
        if (user == nil){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"用户名或密码错误" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return;
        }
        [RORRunHistoryServices syncRunningHistories];
    } else { //注册
        NSDictionary *regDict = [[NSDictionary alloc]initWithObjectsAndKeys:usernameTextField.text, @"userEmail",[RORUtils md5:passwordTextField.text], @"password", nicknameTextField.text, @"nickName", [sexButton selectedSegmentIndex]==0?@"男":@"女", @"sex", nil];
        User_Base *user = [RORUserServices registerUser:regDict];
        
        if (user != nil){
            registerAlert = [[UIAlertView alloc] initWithTitle:@"注册成功" message:@"恭喜你，注册成功！" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
            [registerAlert show];
            // Create and add the activity indicator
            UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [aiv startAnimating];
            [self performSelector:@selector(performDismiss) withObject:nil afterDelay:1.5f];
            return;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"用户名已存在" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [alert show];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入错误" message:@"用户名或密码不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return NO;
        }
    } else {
        if ([usernameTextField.text isEqualToString:@""] ||
            [passwordTextField.text isEqualToString:@""] ||
            [nicknameTextField.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入错误" message:@"用户名,密码或昵称不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

- (IBAction)backgroundTap:(id)sender {
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [nicknameTextField resignFirstResponder];
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
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"Cyberace_赛跑乐"],
                                    SHARE_TYPE_NUMBER(type),nil]];
    
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
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                       message:error.errorDescription
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"知道了"
                                                                             otherButtonTitles: nil];
                                   [alertView show];
                               }
                           }];
}


@end
