//
//  RORSimpleTrainingViewController.h
//  Cyberace
//
//  Created by Bjorn on 13-11-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORTrainingDetailViewController.h"

@interface RORSimpleTrainingViewController : RORTrainingDetailViewController


@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *collectButton;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) IBOutlet UILabel *cycleTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalTimesLabel;
@property (strong, nonatomic) IBOutlet UILabel *trainingContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *speedLabel;
@property (strong, nonatomic) IBOutlet UILabel *planIdLabel;
@property (strong, nonatomic) IBOutlet UIImageView *certifiedIcon;
@property (strong, nonatomic) IBOutlet UILabel *composerLabel;

@property (strong, nonatomic) IBOutlet UIButton *operateButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@end
