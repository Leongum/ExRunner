//
//  RORViewController.h
//  RevolUtioN
//
//  Created by Bjorn on 13-8-20.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Animations.h"
#import "RORConstant.h"
#import "RORUtils.h"
#import "RORNormalButton.h"
#import "RORNotificationView.h"

#define BACKBUTTON_FRAME_NORMAL CGRectMake(25, 375, 44, 44)
#define BACKBUTTON_FRAME_RETINA CGRectMake(25, 460, 44, 44)
#define BACKBUTTON_FRAME_TOP CGRectMake(0, 15, 55, 55)

@interface RORViewController : UIViewController{
    RORNotificationView *notificationView;
}
//-(void)addBackButton;
@property (strong, nonatomic) RORNormalButton *backButton;
- (IBAction)backAction:(id)sender;

-(void)sendNotification:(NSString *)message;
-(void)sendAlart:(NSString *)message;

@end
