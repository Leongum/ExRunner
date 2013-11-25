//
//  RORTrainingCongratsCoverView.h
//  Cyberace
//
//  Created by Bjorn on 13-11-25.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORCongratsCoverView.h"

@interface RORTrainingCongratsCoverView : RORCongratsCoverView{
    UILabel *levelLabel;

}

@property (nonatomic) User_Running_History *bestRecord;

- (id)initWithFrame:(CGRect)frame andLevel:(User_Running_History*)record;

@end
