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
    [self initButtonInteraction];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initButtonInteraction];
        // Initialization code
    }
    return self;
}

-(void)initButtonInteraction{
    [self addTarget:self action:@selector(pressOn:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpOutside];
//    self.adjustsImageWhenDisabled = NO;
    self.adjustsImageWhenHighlighted = YES;
    sound = [[RORPlaySound alloc]initForPlayingSoundEffectWith:@"bo.wav"];
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
    self.transform = CGAffineTransformMakeScale(1, 0.85);
}

-(IBAction)touchUp:(id)sender{
    self.transform = CGAffineTransformMakeScale(1, 1);
//    [sound play];
}

-(IBAction)touchDrag:(id)sender{
    
}



@end
