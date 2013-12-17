//
//  RORPlanCommentView.h
//  Cyberace
//
//  Created by Bjorn on 13-12-17.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RORPlanCommentView : UIControl{
    UIImageView *bgImage;
    UILabel *contentLabel;
}

-(id)initWithFrame:(CGRect)frame andY:(double)y;
-(void)showComment:(NSString *)comment;
-(IBAction)bgTap:(id)sender;
@end
