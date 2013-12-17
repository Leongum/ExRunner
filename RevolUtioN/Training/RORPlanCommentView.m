//
//  RORPlanCommentView.m
//  Cyberace
//
//  Created by Bjorn on 13-12-17.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORPlanCommentView.h"
#import "FTAnimation.h"

@implementation RORPlanCommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andY:(double)y{
    self = [self initWithFrame:frame];
    if (self){
        // Initialization code
        self.alpha = 0;
        self.backgroundColor = [UIColor clearColor];
        
        bgImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tipsPad_bg.png"]];
        bgImage.frame = CGRectMake(21, y, 279, 110);
        [self addSubview:bgImage];
        
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(46, y+10, 239, 80)];
        [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        contentLabel.numberOfLines = 0;
        [contentLabel setFont:[UIFont boldSystemFontOfSize:15]];
        contentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:contentLabel];
        
        [self addTarget:self action:@selector(bgTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)showComment:(NSString *)comment{
    self.alpha = 1;
    contentLabel.text = comment;
    [self fadeIn:0.1 delegate:self];
}

-(IBAction)bgTap:(id)sender{
    [self fadeOut:0.1 delegate:self];
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
