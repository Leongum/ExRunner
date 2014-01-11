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
@dynamic appId;
@dynamic appIcon;
@dynamic appName;
@dynamic appDescription;
@dynamic appAddress;
@dynamic lastUpdateTime;
@dynamic recommendStatus;
@dynamic sequence;


-(void)initWithDictionary:(NSDictionary *)dict{
    self.appId = [RORDBCommon getNumberFromId:[dict valueForKey:@"appId"]];
    self.appIcon = [RORDBCommon getStringFromId:[dict valueForKey:@"appPicLink"]];
    self.appName = [RORDBCommon getStringFromId:[dict valueForKey:@"appName"]];
    self.appDescription = [RORDBCommon getStringFromId:[dict valueForKey:@"appDescription"]];
    self.appAddress = [RORDBCommon getStringFromId:[dict valueForKey:@"appAddress"]];
    self.lastUpdateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"lastUpdateTime"]];
    self.recommendStatus = [RORDBCommon getNumberFromId:[dict valueForKey:@"recommendStatus"]];
    self.sequence = [RORDBCommon getNumberFromId:[dict valueForKey:@"sequence"]];

}

-(NSMutableDictionary *)transToDictionary{
    NSMutableDictionary *tempoDict = [[NSMutableDictionary alloc] init];
    [tempoDict setValue:self.appId forKey:@"appId"];
    [tempoDict setValue:self.appIcon forKey:@"appPicLink"];
    [tempoDict setValue:self.appName forKey:@"appName"];
    [tempoDict setValue:self.appDescription forKey:@"appDescription"];
    [tempoDict setValue:self.appAddress forKey:@"appAddress"];
    [tempoDict setValue:self.lastUpdateTime forKey:@"lastUpdateTime"];
    [tempoDict setValue:self.recommendStatus forKey:@"recommendStatus"];
    [tempoDict setValue:self.sequence forKey:@"sequence"];
    
    return tempoDict;
}


+(Recommend_App *) removeAssociateForEntity:(Recommend_App *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recommend_App" inManagedObjectContext:context];
    Recommend_App *unassociatedEntity = [[Recommend_App alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

@end
