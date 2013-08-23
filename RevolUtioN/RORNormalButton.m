//
//  RORNormalButton.m
//  RevolUtioN
//
//  Created by Bjorn on 13-8-23.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORNormalButton.h"


@implementation RORNormalButton

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [self addTarget:self action:@selector(pressOn:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
//    [self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpOutside];
//    [self addTarget:self action:@selector(touchDrag:) forControlEvents:UIControlEventTouchDragOutside]
//    ;
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self addGestureRecognizer:panGes];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(IBAction)pressOn:(id)sender{
    self.transform = CGAffineTransformMakeScale(1.1, 1.05);
}

-(IBAction)touchUp:(id)sender{
    self.transform = CGAffineTransformMakeScale(1, 1);
}

-(IBAction)touchDrag:(id)sender{
    
}

-(void) panAction:(UIPanGestureRecognizer*) recognizer{
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        originFrame = self.frame;
        normal_bg = self.currentBackgroundImage;
    }
    
    CGPoint translation = [recognizer translationInView:self];
    
    UIImage *scared = [UIImage imageNamed:@"btn_scared.png"];
    if (fabs(translation.x) >50 || fabs(translation.y) > 50){
        [self setBackgroundImage:scared forState:UIControlStateNormal];
    } else {
        [self setBackgroundImage:normal_bg forState:UIControlStateNormal];
    }
    double deltaX = 0, deltaY = 0;
    if (translation.x < 0)
        deltaX = translation.x;
    if (translation.y < 0)
        deltaY = translation.y;
    self.frame = CGRectMake(originFrame.origin.x + deltaX, originFrame.origin.y + deltaY, fabs(translation.x)+originFrame.size.width, fabs(translation.y)+originFrame.size.height);
    CGContextRef gccontext = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:gccontext];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.frame = originFrame;
        [self setBackgroundImage:normal_bg forState:UIControlStateNormal];
        self.transform = CGAffineTransformMakeScale(1, 1);
    }
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
    
//    [recognizer setTranslation:CGPointZero inView:self];
}

@end
