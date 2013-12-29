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
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scrollPicker_bg.png"]];
    bgImageView.frame = self.frame;
    bgImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addSubview:bgImageView];
    
    self.pickerLabelLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 21)];
    self.pickerLabelLeft.textAlignment = NSTextAlignmentCenter;
    self.pickerLabelMid = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 240, 21)];
    self.pickerLabelMid.textAlignment = NSTextAlignmentCenter;
    self.pickerLabelRight = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 21)];
    self.pickerLabelRight.textAlignment = NSTextAlignmentCenter;
    [self.pickerLabelLeft setFont:[UIFont boldSystemFontOfSize:15]];
    [self.pickerLabelMid setFont:[UIFont boldSystemFontOfSize:15]];
    [self.pickerLabelRight setFont:[UIFont boldSystemFontOfSize:15]];
    [self.pickerLabelLeft setTextColor:[UIColor whiteColor]];
    [self.pickerLabelMid setTextColor:[UIColor whiteColor]];
    [self.pickerLabelRight setTextColor:[UIColor whiteColor]];
    
    pickerLabelLeft.backgroundColor = [UIColor clearColor];
    pickerLabelMid.backgroundColor = [UIColor clearColor];
    pickerLabelRight.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.pickerLabelLeft];
    [self addSubview:self.pickerLabelMid];
    [self addSubview:self.pickerLabelRight];
    
    picker = [[UIPickerView alloc]init];
    picker.frame = CGRectMake(0, 0, 235, 183);
    picker.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    picker.showsSelectionIndicator = YES;
    picker.backgroundColor = [UIColor clearColor];
    CALayer* mask = [[CALayer alloc] init];
    [mask setBackgroundColor: [UIColor blackColor].CGColor];
    [mask setFrame:  CGRectMake(10, 10, 215, 163)];
    [mask setCornerRadius: 5.0f];
    [picker.layer setMask: mask];
    
    [self addSubview:picker];
    
    double labelY = pickerLabelLeft.frame.size.height/2+8;
    self.pickerLabelLeft.center = CGPointMake(self.frame.size.width/4, labelY);
    self.pickerLabelRight.center = CGPointMake(self.frame.size.width/4*3, labelY);
    self.pickerLabelMid.center = CGPointMake(picker.center.x, labelY);
    
    okButton = [[UIButton alloc]init];
    okButton.frame = CGRectMake(0, 0, 215, 38);
    okButton.center = CGPointMake(picker.center.x-3, self.frame.size.height-19);
    [okButton setBackgroundColor:[UIColor clearColor]];
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
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
