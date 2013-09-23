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
        self.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:231 green:8 blue:53 alpha:1];
        columns = number;
        [self initTable];
    }
    return self;
}


- (void)initTable{
    int cellHeight = self.frame.size.height/columns;
    int cellWidth = cellHeight * 3;

    for (int i=0; i<columns; i++){
        int labelWidth = cellWidth-cellHeight;
        
        CGRect labelFrame = CGRectMake(self.frame.size.width/2 - cellWidth/6, cellHeight*i, labelWidth, cellHeight);
        CGRect imageFrame = CGRectMake(self.frame.size.width/2 - cellWidth/2, cellHeight*i, cellHeight, cellHeight);

        UILabel *contentLabel = [[UILabel alloc]initWithFrame:labelFrame];
        [contentLabel setFont:[UIFont fontWithName:ENG_WRITTEN_FONT size:15]];
        [contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [contentLabel setTag:i+1];
        [contentLabel setBackgroundColor:[UIColor clearColor]];
        [contentLabel setTextColor:[UIColor whiteColor]];
        contentLabel.textAlignment = UITextAlignmentCenter;
        contentLabel.text = [NSString stringWithFormat:@"%d", i];
        [self addSubview:contentLabel];
        
//        UIImageView *contentImage = [[UIImageView alloc]initWithFrame:imageFrame];
        UILabel *contentImage = [[UILabel alloc]initWithFrame:imageFrame];
        [contentImage setTag:i+columns+1];
        [contentImage setBackgroundColor:[UIColor clearColor]];
        [contentImage setFont:[UIFont fontWithName:ENG_WRITTEN_FONT size:24]];
        contentImage.textAlignment = UITextAlignmentCenter;
        [contentImage setTextColor:[UIColor whiteColor]];
        [contentImage setText:MissionGradeEnum_toString[i]];
        [self addSubview:contentImage];

//        [contentImage setImage:[UIImage imageNamed:MissionGradeImageEnum_toString[i]]];

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
