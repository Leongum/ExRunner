//
//  RORCountDownCoverView.m
//  RevolUtioN
//
//  Created by Bjorn on 13-9-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORCountDownCoverView.h"
#import "Animations.h"
#import "FTAnimation.h"

@implementation RORCountDownCoverView
@synthesize count;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        self.alpha = 0;
        
        bgView = [[UIControl alloc] initWithFrame:frame];
        [bgView setBackgroundColor:[UIColor blackColor]];
        bgView.alpha = 0.5;
        [self addSubview:bgView];
        
        contentImageView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:contentImageView];
        contentImageView.alpha = 0;
//        count = 3;
    }
    return self;
}

-(void)doAnimation{
    contentImageView.alpha = 1;

//    for (int i=0; i<count; i++){
        [contentImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"running_countdown_%d.png", 3]]];
//        [contentImageView fallIn:1 delegate:self];
        [Animations zoomIn:contentImageView andAnimationDuration:1 andWait:YES];
//        [Animations fadeOut:contentImageView andAnimationDuration:0.5 fromAlpha:1 andWait:YES];
//    }
    self.alpha = 0;
}

-(void)show{
    self.alpha = 1;
    [self doAnimation];
}

-(void)hide{
    self.alpha = 0;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
