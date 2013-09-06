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
#import "RORPublicMethods.h"
#import "RORNormalButton.h"
#import "RORNotificationView.h"
@interface RORViewController : UIViewController{
    RORNotificationView *notificationView;
}
//-(void)addBackButton;
@property (strong, nonatomic) RORNormalButton *backButton;

-(void)sendNotification:(NSString *)message;
-(void)sendAlart:(NSString *)message;

@end
