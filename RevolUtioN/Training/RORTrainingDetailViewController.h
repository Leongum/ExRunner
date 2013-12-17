//
//  RORTrainingDetailViewController.h
//  Cyberace
//
//  Created by Bjorn on 13-11-20.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORTrainingViewController.h"
#import "RORPlanCommentView.h"

@interface RORTrainingDetailViewController : RORTrainingViewController{
    RORPlanCommentView *tipPadView;
}

@property (strong, nonatomic) Plan *plan;
@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) Plan_Next_mission *planNext;

-(IBAction)collectAction:(id)sender;
-(IBAction)operateAction:(id)sender;
-(BOOL)isCollectAvailable;
-(void)refreshCollectButton:(UIButton *)btn;

@end
