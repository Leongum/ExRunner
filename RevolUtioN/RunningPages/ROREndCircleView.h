//
//  ROREndCircleView.h
//  Cyberace
//
//  Created by Bjorn on 16/6/4.
//  Copyright © 2016年 Beyond. All rights reserved.
//

#import "TCircleView.h"


#define CYCLE_LINE_WIDTH 7
#define TRIGGER_TIME 1.5

@interface ROREndCircleView : TCircleView{
    NSTimer *repeatingTimer;
    NSInteger timerCount;
    BOOL triggered;
}

@property (strong, nonatomic) id delegate;

-(IBAction)clickAction:(id)sender;

@end
