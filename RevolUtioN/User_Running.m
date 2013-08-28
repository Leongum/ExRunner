//
//  User_Running.m
//  RevolUtioN
//
//  Created by leon on 13828.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "User_Running.h"
#import "RORDBCommon.h"

@implementation User_Running

@dynamic commitTime;
@dynamic endTime;
@dynamic missionId;
@dynamic missionStatus;
@dynamic missionTypeId;
@dynamic runUuid;
@dynamic startTime;
@dynamic userId;

+(User_Running *) removeAssociateForEntity:(User_Running *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Running" inManagedObjectContext:context];
    User_Running *unassociatedEntity = [[User_Running alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    return unassociatedEntity;
}

-(NSMutableDictionary *)transToDictionary{
    NSMutableDictionary *tempoDict = [[NSMutableDictionary alloc] init];
    [tempoDict setValue:self.userId forKey:@"userId"];
    [tempoDict setValue:self.runUuid forKey:@"runUuid"];
    [tempoDict setValue:self.missionId forKey:@"missionId"];
    [tempoDict setValue:self.missionTypeId forKey:@"missionTypeId"];
    [tempoDict setValue:self.missionStatus forKey:@"missionStatus"];
    [tempoDict setValue:[RORDBCommon getStringFromId:self.startTime] forKey:@"startTime"];
    [tempoDict setValue:[RORDBCommon getStringFromId:self.startTime] forKey:@"endTime"];
    [tempoDict setValue:[RORDBCommon getStringFromId:self.commitTime] forKey:@"commitTime"];
    return tempoDict;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.userId = [RORDBCommon getNumberFromId:[dict valueForKey:@"userId"]];
    self.runUuid = [RORDBCommon getStringFromId:[dict valueForKey:@"runUuid"]];
    self.missionId = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionId"]];
    self.missionTypeId = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionTypeId"]];
    self.missionStatus = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionStatus"]];
    self.startTime = [RORDBCommon getDateFromId:[dict valueForKey:@"startTime"]];
    self.endTime = [RORDBCommon getDateFromId:[dict valueForKey:@"endTime"]];
    self.commitTime = [RORDBCommon getDateFromId:[dict valueForKey:@"commitTime"]];
}
@end
