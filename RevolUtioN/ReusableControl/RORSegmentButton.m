//
//  RORSegmentButton.m
//  RevolUtioN
//
//  Created by Bjorn on 13-9-16.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORSegmentButton.h"

@implementation RORSegmentButton
@synthesize  seg_index, selected;

- (id)initWithFrame:(CGRect)frame Style:(NSInteger)style andIndex:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.adjustsImageWhenHighlighted = NO;
        self.adjustsImageWhenDisabled = NO;
        seg_index = index;
        selected = NO;
        seg_style = style;
        [self setBackgroundImage:[self imageForStyle:style andSelection:NO] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont fontWithName:CHN_PRINT_FONT size:14]];
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

-(UIImage *)imageForStyle:(NSInteger)style andSelection:(BOOL)isSelected
{
    NSString *imageName = [NSString stringWithFormat:@"segment_button_%d_%@.png",style, isSelected?@"selected":@"unselected"];
    return [UIImage imageNamed:imageName];
}

-(IBAction)refreshAppearence:(id)sender{
//    selected = !selected;
    [self setBackgroundImage:[self imageForStyle:seg_style andSelection:selected] forState:UIControlStateNormal];
}

@end