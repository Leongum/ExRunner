//
//  RORCityPickerViewController.m
//  RevolUtioN
//
//  Created by Beyond on 13-5-29.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORCityPickerViewController.h"
#import "RORMoreViewController.h"
#import "RORUtils.h"
#import "RORSettings.h"

#define PROVINCECOMPONENT 0
#define CITYCOMPONENT 1

@interface RORCityPickerViewController ()

@end

@implementation RORCityPickerViewController
@synthesize citycodeList;
@synthesize delegate;
@synthesize cityPickerView;
@synthesize subLocalityName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSError *error;
    NSData *CityCodeJson = [NSData dataWithContentsOfFile:[RORUtils getCityCodeJSon]];
    NSDictionary *citycodeDic = [NSJSONSerialization JSONObjectWithData:CityCodeJson options:NSJSONReadingMutableLeaves error:&error];
    //    weatherDic字典中存放的数据也是字典型，从它里面通过键值取值
    citycodeList = [citycodeDic objectForKey:@"城市代码"];
    NSString *jsonString = [[NSString alloc] initWithData:CityCodeJson encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", jsonString);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [cityPickerView selectRow:3 inComponent:1 animated:NO];
//    for (int i=0; i<citycodeList.count; i++){
//        NSDictionary *prov = [citycodeList objectAtIndex:i];
//        NSArray *cityList = [prov objectForKey:@"市"];
//        for (int j=0; j<cityList.count; j++){
//            NSDictionary *city = [cityList objectAtIndex:j];
//            NSString *cityName = [city valueForKey:@"市名"];
//            if ([cityName isEqualToString:subLocalityName]){
//                [cityPickerView selectRow:i inComponent:0 animated:NO];
//                [cityPickerView selectRow:j inComponent:1 animated:NO];
//                return;
//            }
//        }
//    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCityPickerView:nil];
    [super viewDidUnload];
}

- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)okAction:(id)sender {
    RORMoreViewController * controller = (RORMoreViewController *)delegate;
    NSInteger pNum = [cityPickerView selectedRowInComponent:PROVINCECOMPONENT];
    NSDictionary *prov = [citycodeList objectAtIndex:pNum];
    NSArray *cityList = [prov objectForKey:@"市"];
    NSDictionary *city = [cityList objectAtIndex:[cityPickerView selectedRowInComponent:CITYCOMPONENT]];
    controller.cityName = [city valueForKey:@"市名"];
    controller.cityCode = [city valueForKey:@"编码"];
    controller.provRow = [[NSNumber alloc] initWithInteger:[cityPickerView selectedRowInComponent:PROVINCECOMPONENT]];
    controller.cityRow = [[NSNumber alloc]initWithInteger:[cityPickerView selectedRowInComponent:CITYCOMPONENT]];
    
    [controller.moreTableView reloadData];
    [controller saveAll];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0){//左侧用来显示省的列
        return citycodeList.count;
    } else {//右侧用来显示市的列
        NSInteger pNum = [pickerView selectedRowInComponent:0];
        NSDictionary *prov = [citycodeList objectAtIndex:pNum];
        NSArray *cityList = [prov objectForKey:@"市"];
        return cityList.count;
    }
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0){//省列
        NSDictionary *prov = [citycodeList objectAtIndex:row];
        return [prov objectForKey:@"省"];
    }else {//市列
        NSInteger pNum = [pickerView selectedRowInComponent:0];
        NSDictionary *prov = [citycodeList objectAtIndex:pNum];
        NSArray *cityList = [prov objectForKey:@"市"];
        NSDictionary *city = [cityList objectAtIndex:row];
        return [city valueForKey:@"市名"];;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        [pickerView reloadComponent:1];
    }
}

- (IBAction) btnAction{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"1233aagggddbc"forKey:@"terminalID"];
    [mDict setObject:@"11111111"forKey:@"docNo"];
    NSString *JSONString = @" ";//[mDict JSONFragment];
    NSLog(@"Format JSON : %@", [JSONString description]);
    NSURL*url= [NSURL URLWithString:@"_blank>http://11.11.18.29:8083/"];
    NSURL *dataURL=[NSURL URLWithString:url];
    NSData*postData = [JSONString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *requestPOST = [[NSMutableURLRequest alloc] init];
    [requestPOST setURL:dataURL];
    [requestPOST setHTTPMethod:@"POST"];
    [requestPOST setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [requestPOST setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    [requestPOST setHTTPBody:postData];
    
    NSURLResponse*response= nil;
    NSError *error = nil;
    [NSURLConnection sendSynchronousRequest:requestPOST returningResponse : &response   error : &error   ]; // error         // response
}

@end
