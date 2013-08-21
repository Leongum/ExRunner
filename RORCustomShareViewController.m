//
//  RORCustomShareViewController.m
//  RevolUtioN
//
//  Created by leon on 13-8-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORCustomShareViewController.h"
#import <AGCommon/UIImage+Common.h>
#import <AGCommon/UIDevice+Common.h>
#import <AGCommon/UINavigationBar+Common.h>
#import <AGCommon/UIColor+Common.h>

#define CONTENT @"这里就是传说中的固定内容"
#define SHARE_MAX_CONTENT 70

@implementation RORCustomShareViewController

@synthesize shareImage;

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
    _txtShareContent.delegate = self;
    [_txtShareContent becomeFirstResponder];
    _lblContentCount.text = [NSString stringWithFormat:@"%d/%d", SHARE_MAX_CONTENT, SHARE_MAX_CONTENT];
}

- (void)updateWordCount
{
    
    NSInteger count = SHARE_MAX_CONTENT - [_txtShareContent.text length];
    _lblContentCount.text = [NSString stringWithFormat:@"%d/%d", count, SHARE_MAX_CONTENT];
    
    if (count < 0)
    {
        _lblContentCount.textColor = [UIColor redColor];
    }
    else
    {
        _lblContentCount.textColor = [UIColor lightGrayColor];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateWordCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareContentAction:(id)sender {
    RORAppDelegate *appDelegate = (RORAppDelegate *)[UIApplication sharedApplication].delegate;
    NSArray *selectedClients = [_shareBar selectedClients];
    if ([selectedClients count] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请选择要发布的平台!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    NSString *shareContent = [NSString stringWithFormat:@"%@ %@",_txtShareContent.text,CONTENT];
    
    id<ISSContent> publishContent = [ShareSDK content:shareContent
                                       defaultContent:nil
                                                image:[ShareSDK jpegImageWithImage:shareImage quality:1]
                                                title:@"赛跑乐快乐分享"
                                                  url:@"http://www.cyberace.cc"
                                          description:@"来自赛跑乐的晒跑了"
                                            mediaType:SSPublishContentMediaTypeText];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:appDelegate.viewDelegate
                                               authManagerViewDelegate:nil];
    
    [authOptions setPowerByHidden:true];
    
    //分享内容
    [ShareSDK oneKeyShareContent:publishContent
                       shareList:selectedClients
                     authOptions:authOptions
                   statusBarTips:YES
                          result:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setTxtShareContent:nil];
    [self setLblContentCount:nil];
    [self setShareBar:nil];
    [super viewDidUnload];
}

- (IBAction)popBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
