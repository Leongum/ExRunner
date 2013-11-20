//
//  RORTrainingDetailViewController.h
//  Cyberace
//
//  Created by Bjorn on 13-11-20.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORTrainingViewController.h"

@interface RORTrainingDetailViewController : RORTrainingViewController{

}

@property (strong, nonatomic) Plan *plan;

-(IBAction)collectAction:(id)sender;
-(IBAction)operateAction:(id)sender;
@end
