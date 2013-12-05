//
//  RORTrainingPickerView.h
//  Cyberace
//
//  Created by Bjorn on 13-12-3.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerCoverViewDelegate
@optional
- (void) didFinishPicking;
@end

@interface RORTrainingPickerView : UIControl{
    UIButton *okButton;
}

@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) UILabel *pickerLabelLeft;
@property (strong, nonatomic) UILabel *pickerLabelMid;
@property (strong, nonatomic) UILabel *pickerLabelRight;

@property (strong, nonatomic) UIPickerView *picker;

-(void)showMiddleTitle:(NSString *)t;
-(void)showBothSideTitle:(NSString *)t1 t2:(NSString *)t2;

@end
