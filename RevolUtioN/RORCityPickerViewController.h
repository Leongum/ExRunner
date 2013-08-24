//
//  RORCityPickerViewController.h
//  RevolUtioN
//
//  Created by Beyond on 13-5-29.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RORCityPickerViewController : UIViewController{
    NSString *administrativeAreaName;
}

@property (weak, nonatomic) IBOutlet UIPickerView *cityPickerView;
@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) NSArray *citycodeList;
@property (strong, nonatomic) NSString *subLocalityName;

- (IBAction)cancelAction:(id)sender;
- (IBAction)okAction:(id)sender;

@end
