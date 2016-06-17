//
//  ROREndCircleView.m
//  Cyberace
//
//  Created by Bjorn on 16/6/4.
//  Copyright © 2016年 Beyond. All rights reserved.
//

#import "ROREndCircleView.h"

#define END_CIRCLE_COLOR_BACKGROUND [UIColor colorWithRed:81.0/255.0 green:85.0/255.0 blue:89.0/255.0 alpha:1]
#define END_CIRCLE_COLOR_CIRCLE [UIColor colorWithRed:255.0/255.0 green:105.0/255.0 blue:32.0/255.0 alpha:1]

@implementation ROREndCircleView
@synthesize delegate;

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initConfig];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}
//
-(void)initConfig{
    self.circleBackgroundColor = END_CIRCLE_COLOR_BACKGROUND;
    self.startColor = END_CIRCLE_COLOR_CIRCLE;
    self.endColor = END_CIRCLE_COLOR_CIRCLE;
    self.centerColor = END_CIRCLE_COLOR_CIRCLE;
    self.lineWidth = 7;
    self.startAngle = DEGREES_TO_RADOANS(-90);
    self.endAngle = DEGREES_TO_RADOANS(270);
    self.clockWiseType = YES;
}

//-(void)initSubviews{
//    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.bounds];
//    [bgImageView setBackgroundColor:[UIColor clearColor]];
//    [bgImageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin];
//    [bgImageView setImage:[UIImage imageNamed:@"icon_end.png"]];
//    [self addSubview:bgImageView];
//    [self bringSubviewToFront:bgImageView];
//    
//    self.persentage = 0.0;
//}

//-(void)awakeFromNib{
//    [super awakeFromNib];
//    [self initSubviews];
//}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [super touchesBegan:touches withEvent:event];
    [self pressOn:self];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if (triggered){
        triggered = NO;
        [self stopTimer];
    } else {
        [self pressCanceled:self];
    }
}

-(IBAction)pressOn:(id)sender{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerDot) userInfo:nil repeats:YES];
    repeatingTimer = timer;
    triggered = NO;
    timerCount = 0;
}

-(IBAction)pressCanceled:(id)sender{
    [self stopTimer];
    self.persentage = 0;
}

-(void)stopTimer{
    [repeatingTimer invalidate];
    repeatingTimer = nil;
}

-(IBAction)clickAction:(id)sender{
    if ([delegate respondsToSelector:@selector(btnEndAction:)]){
        [delegate performSelector:@selector(btnEndAction:) withObject:NULL afterDelay:0];
    }
}

- (void)timerDot{
    timerCount++;
    self.persentage = (float)timerCount / 150.0;
    if (timerCount == 150){
        triggered = YES;
        [self stopTimer];
        [self clickAction:self];
    }
}


@end
