//
//  RORViewController.m
//  RevolUtioN
//
//  Created by Bjorn on 13-8-20.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORViewController.h"
#import "FTAnimation.h"

@interface RORViewController ()

@end

@implementation RORViewController
@synthesize backButton;
@synthesize activityIndicator = _activityIndicator;
@synthesize progressView = _progressView;


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
    [self.view setAutoresizesSubviews:YES];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addBackButton];
}

-(void)viewDidUnload{
    [self setBackButton:nil];
    [self setActivityIndicator:nil];
    [self setProgressView:nil];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)addBackButton{
    backButton = [[RORNormalButton alloc]initWithFrame:BACKBUTTON_FRAME_TOP ];//[RORNormalButton buttonWithType:UIButtonTypeRoundedRect];
//    [backButton initButtonInteraction];
    backButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    //CGRect rx = [ UIScreen mainScreen ].applicationFrame;
//    backButton.frame = BACKBUTTON_FRAME_TOP;
//    if (rx.size.height == 460){
//        backButton.frame = BACKBUTTON_FRAME_NORMAL;
//    } else {
//        backButton.frame = BACKBUTTON_FRAME_RETINA;
//    }
    UIImage *image = [UIImage imageNamed:@"back_bg.png"];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendNotification:(NSString *)message{
    if (notificationView == nil){
        notificationView = [[RORNotificationView alloc]init];
        [self.view addSubview:notificationView];
    }
    [notificationView popNotification:self Message:message];
}

-(void)sendAlart:(NSString *)message{
    if (notificationView == nil){
        notificationView = [[RORNotificationView alloc]init];
        [self.view addSubview:notificationView];
    }
    [notificationView popNotification:self Message:message andType:RORNOTIFICATION_TYPE_IMPORTANT];
}


/**
activity indicator
*/

- (IBAction)startIndicator:(id)sender
{
    //初始化指示器
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-25, self.view.frame.size.height/2-25, 50, 50)];
    
    /*
     指定指示器的类型
     一共有三种类型：
     UIActivityIndicatorViewStyleWhiteLarge   //大型白色指示器
     UIActivityIndicatorViewStyleWhite      //标准尺寸白色指示器
     UIActivityIndicatorViewStyleGray    //灰色指示器，用于白色背景
     */
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    
    //停止后是否隐藏(默认为YES)
    self.activityIndicator.hidesWhenStopped = YES;
    
    //将Indicator添加到视图中
    [self.view addSubview:self.activityIndicator];
    
    //开始转动
    [self.activityIndicator startAnimating];
    
    //操作队列
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    
    //设置最大的操作数
    [operationQueue setMaxConcurrentOperationCount:1];
    
    //构建一个操作对象，selector指定的方法是在另外一个线程中运行的
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(runIndicator) object:nil];
    //将操作加入队列，此时后台线程开始执行
    [operationQueue addOperation:operation];
    
}

- (IBAction)endIndicator:(id)sender{
    [self.activityIndicator stopAnimating];
}

- (IBAction)startProgress:(id)sender
{
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(70, 260, 180, 20)];
    /*
     设置风格属性
     有两种风格属性：
     UIProgressViewStyleDefault
     UIProgressViewStyleBar
     */
    self.progressView.progressViewStyle = UIProgressViewStyleDefault;
    
    //设置进度，值为0——1.0的浮点数
    //    self.progressView.progress = .5;
    [self.view addSubview:self.progressView];
    
    //设定计时器，每隔1s调用一次runProgress方法
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runProgress)   userInfo:nil repeats:YES];
}

//在状态栏显示有网络请求的提示器
- (IBAction)startNetWork:(id)sender
{
    UIApplication *app = [UIApplication sharedApplication];
    if (app.isNetworkActivityIndicatorVisible) {
        app.networkActivityIndicatorVisible = NO;
    }else {
        app.networkActivityIndicatorVisible = YES;
    }
}

-(void)runIndicator
{
    //开启线程并睡眠三秒钟
    [NSThread sleepForTimeInterval:3];
    //停止UIActivityIndicatorView
    [self.activityIndicator stopAnimating];
}

//增加progressView的进度
-(void)runProgress
{
    self.progressView.progress += .1;
}

@end
