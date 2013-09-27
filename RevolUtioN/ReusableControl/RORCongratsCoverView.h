//
//  RORCongratsCoverView.h
//  RevolUtioN
//
//  Created by Bjorn on 13-9-26.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RORRunHistoryServices.h"

@interface RORCongratsCoverView : UIControl{
    UIImageView *bgView;
    UILabel *titleLabel;
    UILabel *levelLabel;
    UILabel *extraAwardLabel;
    UILabel *awardTitleLabel;
}

@property (nonatomic) User_Running_History *bestRecord;

- (id)initWithFrame:(CGRect)frame andLevel:(User_Running_History*)record;
-(IBAction)show:(id)sender;
-(IBAction)hide:(id)sender;
@end
