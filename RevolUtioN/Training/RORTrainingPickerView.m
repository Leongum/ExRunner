//
//  RORTrainingPickerView.m
//  Cyberace
//
//  Created by Bjorn on 13-12-3.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORTrainingPickerView.h"

@implementation RORTrainingPickerView
@synthesize picker, pickerLabelLeft, pickerLabelRight, pickerLabelMid;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initLayout];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initLayout];
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

-(void)setDelegate:(id)d{
    delegate = d;
    picker.delegate = d;
    picker.dataSource = d;
}

- (void)initLayout{
    
    self.pickerLabelLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 21)];
    self.pickerLabelLeft.textAlignment = NSTextAlignmentCenter;
    self.pickerLabelMid = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 240, 21)];
    self.pickerLabelMid.textAlignment = NSTextAlignmentCenter;
    self.pickerLabelRight = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 21)];
    self.pickerLabelRight.textAlignment = NSTextAlignmentCenter;

    [self addSubview:self.pickerLabelLeft];
    [self addSubview:self.pickerLabelMid];
    [self addSubview:self.pickerLabelRight];
    
    picker = [[UIPickerView alloc]init];
    picker.frame = CGRectMake(0, 0, self.frame.size.width, self.picker.frame.size.height);
    picker.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CALayer *pickerLayer = picker.layer;
//    [pickerLayer setBounds:CGRectMake(0.0, 0.0, 125.0, 132.0)];
    [pickerLayer setBackgroundColor:[UIColor clearColor].CGColor];
    [pickerLayer setBorderWidth:0];
    [pickerLayer setBorderColor:[UIColor clearColor].CGColor];
    
    [self addSubview:picker];
    
    double labelY = picker.center.y - picker.frame.size.height/2 -5 - pickerLabelLeft.frame.size.height/2;
    self.pickerLabelLeft.center = CGPointMake(self.frame.size.width/4, labelY);
    self.pickerLabelRight.center = CGPointMake(self.frame.size.width/4*3, labelY);
    self.pickerLabelMid.center = CGPointMake(picker.center.x, labelY);
    
    okButton = [[UIButton alloc]init];
    okButton.frame = CGRectMake(0, 0, 240, 40);
    okButton.center = CGPointMake(picker.center.x, picker.center.y + picker.frame.size.height/2 + okButton.frame.size.height/2);
    [okButton setBackgroundColor:[UIColor darkGrayColor]];
    [okButton setTitle:@"OK" forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(okButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:okButton];
    
    self.alpha = 0;
    
}

-(IBAction)okButtonAction:(id)sender{
    self.alpha = 0;
    if ([delegate respondsToSelector:@selector(didFinishPicking)]){
        [delegate didFinishPicking];
    }
}

-(void)showMiddleTitle:(NSString *)t{
    self.pickerLabelLeft.alpha = 0;
    self.pickerLabelRight.alpha = 0;
    self.pickerLabelMid.alpha = 1;
    self.pickerLabelMid.text = t;
}

-(void)showBothSideTitle:(NSString *)t1 t2:(NSString *)t2{
    self.pickerLabelLeft.alpha = 1;
    self.pickerLabelRight.alpha = 1;
    self.pickerLabelMid.alpha = 0;
    self.pickerLabelLeft.text = t1;
    self.pickerLabelRight.text = t2;
}
@end
