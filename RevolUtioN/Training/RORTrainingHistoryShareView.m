//
//  RORTrainingHistoryShareView.m
//  Cyberace
//
//  Created by Bjorn on 13-12-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORTrainingHistoryShareView.h"

@implementation RORTrainingHistoryShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        contentViewList = [[NSMutableArray alloc]init];
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

-(void)add:(UIView *)view2add{
    view2add.center = CGPointMake(view2add.frame.size.width/2, view2add.frame.size.height * contentViewList.count + view2add.frame.size.height/2);
    [self addSubview:view2add];
    [contentViewList addObject:view2add];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y
                            , self.frame.size.width, view2add.frame.size.height*contentViewList.count);
}

-(UIImage *)getImage{
    
    return [RORUtils getImageFromView:self];;
}

@end
