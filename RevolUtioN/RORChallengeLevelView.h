//
//  RORChallengeLevelView.h
//  RevolUtioN
//
//  Created by Bjorn on 13-8-29.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RORChallengeLevelView : UIControl{
    int columns;
}

@property (strong, nonatomic) NSMutableArray *tableCell;
- (id)initWithFrame:(CGRect)frame andNumberOfColumns:(NSInteger)number;

@end