//
//  RORLoginCheckViewController.h
//  RevolUtioN
//
//  Created by leon on 13-8-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import "RORShareService.h"
#import "RORViewController.h"

@interface RORLoginCheckViewController : RORViewController

- (IBAction)sinaWeiboLogin:(id)sender;
- (IBAction)tencentWeiboLogin:(id)sender;
- (IBAction)qqAccountLogin:(id)sender;
- (IBAction)renrenAccountLogin:(id)sender;
- (IBAction)selfAccountLogin:(id)sender;

@end
