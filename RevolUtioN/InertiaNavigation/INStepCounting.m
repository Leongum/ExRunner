//
//  INStepCounting.m
//  InertiaNavigation
//
//  Created by Bjorn on 13-8-12.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "INStepCounting.h"

@implementation INStepCounting
@synthesize gAccList, levelAccList, counter, dSum;

-(id)init{
    self = [super init];
    counter = 0;
    gAccTrend = 0;
    lAccTrend = 0;
    p=0;
    gAccList = [[NSMutableArray alloc]init];
    levelAccList = [[NSMutableArray alloc]init];
    
    totalPoints = 0;
    head = 0;
    tail = 0;
    duration = 0;
    dSum = 0;
    
    return self;
}

-(void)pushNewLAcc:(double)lAcc GAcc:(double)gAcc speed:(double)v{
    
     //push new point into window
    gWindow[tail] = gAcc;
    lWindow[tail] = lAcc;
    tail = [self pointerMoveRight:tail];
    if (head == tail)
        head = [self pointerMoveRight:tail];
    totalPoints++;
    //dequeue one step if exist
    if (totalPoints>4)
        [self checkStep:v];
}

-(void)checkStep:(double)v{
    double maxFrequency = MIN_STEP_TIME / delta_T;
    double slowrunFrequency = 1/(3*delta_T);
    
    if (v < 20/3.6){ // 20km/h, as slow running or walk
        if (totalPoints - lastGPeak < slowrunFrequency)
            return;
    } else {
        if (totalPoints - lastGPeak < maxFrequency)
            return;
    }
    
    [self updateGAccPeak];
}

-(void)oneStepFound{
    counter++;
//    head = tail-1;
    lastGPeak = totalPoints -1;
//    if (duration>=0)
//        dSum += duration;
//    head = (tail -1 + SC_WINDOW_SIZE)%SC_WINDOW_SIZE;
//    duration = (tail-gPeak-1 + SC_WINDOW_SIZE)%SC_WINDOW_SIZE;
//    gHasPeak = NO;
//    lHasPeak = NO;
//    gPeak = -1;
//    lPeak = -1;
}

-(void)updateGAccPeak{
    int now = gWindow[[self pointerMoveLeft:tail for:3]];
    int pre = gWindow[[self pointerMoveLeft:tail for:4]];
    int before = gWindow[[self pointerMoveLeft:tail for:5]];
    int next = gWindow[[self pointerMoveLeft:tail for:2]];
    int far = gWindow[[self pointerMoveLeft:tail for:1]];
    
    if (now<pre && now<before && now<next && now<far && now<THRESHOLD_GACC){
        if (pre<before || next<far){
            [self oneStepFound];
        }
    }
    
//    double current = gWindow[(tail-1+SC_WINDOW_SIZE)%SC_WINDOW_SIZE];
//    double former = gWindow[(tail-2+SC_WINDOW_SIZE)%SC_WINDOW_SIZE];
//    if (!gHasPeak){
//        if (gAccTrend<0 && current-former>0 && round(former)<-10){
//            gHasPeak = YES;
//            gPeak = (tail-2+SC_WINDOW_SIZE)%SC_WINDOW_SIZE;
//        }
//    }
//    if (fabs(current-former)>=0.001)
//        gAccTrend = current - former;
}

-(void)updateLAccPeak{
//    double current = lWindow[(tail-1+SC_WINDOW_SIZE)%SC_WINDOW_SIZE];
//    double former = lWindow[(tail-2+SC_WINDOW_SIZE)%SC_WINDOW_SIZE];
////    if (!lHasPeak){
//        if (lAccTrend>0 && current-former<0 && round(former)>10){
//            lHasPeak = YES;
//            lPeak = (tail-2+SC_WINDOW_SIZE)%SC_WINDOW_SIZE;
//        }
////    }
//    if (fabs(current-former)>=0.001)
//        lAccTrend = current - former;
}

-(int)pointerMoveLeft:(int)pointer for:(int)num{
    return (pointer - (num%SC_WINDOW_SIZE) + SC_WINDOW_SIZE) % SC_WINDOW_SIZE;
}

-(int)pointerMoveLeft:(int)pointer{
    return [self pointerMoveLeft:pointer for:1];
}

-(int)pointerMoveRight:(int)pointer for:(int)num{
    return (pointer + num) % SC_WINDOW_SIZE;
}

-(int)pointerMoveRight:(int)pointer{
    return [self pointerMoveRight:pointer for:1];
}



@end

