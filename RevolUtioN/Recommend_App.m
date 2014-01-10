//
//  Recommend_App.m
//  Cyberace
//
//  Created by Bjorn on 14-1-10.
//  Copyright (c) 2014年 Beyond. All rights reserved.
//

#import "Recommend_App.h"
#import "RORDBCommon.h"

@implementation Recommend_App

@dynamic appIcon;
@dynamic appName;
@dynamic appDescription;
@dynamic appAddress;
@dynamic lastUpdateTime;
@dynamic status;
@dynamic sequence;


-(void)initWithDictionary:(NSDictionary *)dict{
    self.appIcon = [RORDBCommon getStringFromId:[dict valueForKey:@"app_id"]];
    self.appName = [RORDBCommon getStringFromId:[dict valueForKey:@"app_name"]];
    self.appDescription = [RORDBCommon getStringFromId:[dict valueForKey:@"app_description"]];
    self.appAddress = [RORDBCommon getStringFromId:[dict valueForKey:@"app_pic_link"]];
    self.lastUpdateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"last_update_time"]];
    self.status = [RORDBCommon getNumberFromId:[dict valueForKey:@"recommend_status"]];
    self.sequence = [RORDBCommon getNumberFromId:[dict valueForKey:@"sequence"]];

}

-(NSMutableDictionary *)transToDictionary{
    NSMutableDictionary *tempoDict = [[NSMutableDictionary alloc] init];
    [tempoDict setValue:self.appIcon forKey:@"app_id"];
    [tempoDict setValue:self.appName forKey:@"app_name"];
    [tempoDict setValue:self.appDescription forKey:@"app_description"];
    [tempoDict setValue:self.appAddress forKey:@"app_pic_link"];
    [tempoDict setValue:self.lastUpdateTime forKey:@"last_update_time"];
    [tempoDict setValue:self.status forKey:@"recommend_status"];
    [tempoDict setValue:self.sequence forKey:@"sequence"];
    
    return tempoDict;
}


@end
