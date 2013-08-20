//
//  RORCustomShareViewController.h
//  RevolUtioN
//
//  Created by leon on 13-8-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AGCommon/CMImageView.h>
#import <ShareSDK/ShareSDK.h>
#import "RORCustomShareViewToolbar.h"

@interface RORCustomShareViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *txtShareContent;
@property (weak, nonatomic) IBOutlet UILabel *lblContentCount;
@property (weak, nonatomic) IBOutlet RORCustomShareViewToolbar *shareBar;
@property (retain, nonatomic) UIImage *shareImage;


- (IBAction)shareContentAction:(id)sender;

@end
