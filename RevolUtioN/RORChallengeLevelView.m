//
//  RORChallengeLevelView.m
//  RevolUtioN
//
//  Created by Bjorn on 13-8-29.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORChallengeLevelView.h"

@implementation RORChallengeLevelView

- (id)initWithFrame:(CGRect)frame andNumberOfColumns:(NSInteger)number
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor redColor];//[UIColor colorWithRed:231 green:8 blue:53 alpha:1];
        columns = number;
        [self initTable];
    }
    return self;
}


- (void)initTable{
    int cellWidth = self.frame.size.width/columns;
    int halfHeight = self.frame.size.height/2;
    for (int i=0; i<columns; i++){
        CGRect thisFrame = CGRectMake(i*cellWidth, halfHeight, cellWidth, halfHeight);
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:thisFrame];
        [contentLabel setFont:[UIFont fontWithName:@"FZKaTong-M19S" size:12]];
        [contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [contentLabel setTag:i];
        [contentLabel setBackgroundColor:[UIColor clearColor]];
        [contentLabel setTextColor:[UIColor blackColor]];
        contentLabel.textAlignment = UITextAlignmentCenter;
        contentLabel.text = [NSString stringWithFormat:@"%d", i];
        [self addSubview:contentLabel];
//        [self.tableCell addObject:contentLabel];
    }
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
