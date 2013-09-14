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
    [self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpOutside];
//    [self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpOutside];
//    [self addTarget:self action:@selector(touchDrag:) forControlEvents:UIControlEventTouchDragOutside]
//    ;
    sound = [[RORPlaySound alloc]initForPlayingSoundEffectWith:@"bo.wav"];

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
    self.transform = CGAffineTransformMakeScale(0.9, 0.85);
}

-(IBAction)touchUp:(id)sender{
    self.transform = CGAffineTransformMakeScale(1, 1);
    [sound play];
}

-(IBAction)touchDrag:(id)sender{
    
}



@end
