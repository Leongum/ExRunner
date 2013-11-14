//
//  Plan.m
//  Cyberace
//
//  Created by leon on 13-11-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "Plan.h"
#import "RORDBCommon.h"
#import "Mission.h"

@implementation Plan

@dynamic cycleTime;
@dynamic duration;
@dynamic durationLast;
@dynamic durationType;
@dynamic lastUpdateTime;
@dynamic missionIds;
@dynamic planDescription;
@dynamic planId;
@dynamic planName;
@dynamic planShareUser;
@dynamic planShareUserName;
@dynamic planStatus;
@dynamic planType;
@dynamic sharedPlan;
@dynamic totalMissions;

@synthesize missions;

+(Plan *) intiUnassociateEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Plan" inManagedObjectContext:context];
    Plan *unassociatedEntity = [[Plan alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    return unassociatedEntity;
}

+(Plan *) removeAssociateForEntity:(Plan *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Plan" inManagedObjectContext:context];
    Plan *unassociatedEntity = [[Plan alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    NSMutableArray *newMissionList = [[NSMutableArray alloc] init];
    for (Mission *newMission in associatedEntity.missions) {
        [newMissionList addObject:[Mission removeAssociateForEntity:newMission]];
    }
    unassociatedEntity.missions = [newMissionList copy];
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.cycleTime = [RORDBCommon getNumberFromId:[dict valueForKey:@"cycleTime"]];
    self.duration = [RORDBCommon getNumberFromId:[dict valueForKey:@"duration"]];
    self.durationLast = [RORDBCommon getNumberFromId:[dict valueForKey:@"durationLast"]];
    self.durationType = [RORDBCommon getNumberFromId:[dict valueForKey:@"durationType"]];
    self.lastUpdateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"lastUpdateTime"]];
    self.missionIds = [RORDBCommon getStringFromId:[dict valueForKey:@"missionIds"]];
    self.planId = [RORDBCommon getNumberFromId:[dict valueForKey:@"planId"]];
    self.planName = [RORDBCommon getStringFromId:[dict valueForKey:@"planName"]];
    self.planShareUser = [RORDBCommon getNumberFromId:[dict valueForKey:@"planShareUser"]];
    self.planShareUserName = [RORDBCommon getStringFromId:[dict valueForKey:@"planShareUserName"]];
    self.planStatus = [RORDBCommon getNumberFromId:[dict valueForKey:@"planStatus"]];
    self.planType = [RORDBCommon getNumberFromId:[dict valueForKey:@"planType"]];
    self.sharedPlan = [RORDBCommon getNumberFromId:[dict valueForKey:@"sharedPlan"]];
    self.totalMissions = [RORDBCommon getNumberFromId:[dict valueForKey:@"totalMissions"]];
}

-(NSMutableDictionary *)transToDictionary{
    NSMutableDictionary *tempoDict = [[NSMutableDictionary alloc] init];
    [tempoDict setValue:self.cycleTime forKey:@"cycleTime"];
    [tempoDict setValue:self.duration forKey:@"duration"];
    [tempoDict setValue:self.durationLast forKey:@"durationLast"];
    [tempoDict setValue:self.durationType forKey:@"durationType"];
    [tempoDict setValue:self.lastUpdateTime forKey:@"lastUpdateTime"];
    [tempoDict setValue:self.missionIds forKey:@"missionIds"];
    [tempoDict setValue:self.planId forKey:@"planId"];
    [tempoDict setValue:self.planName forKey:@"planName"];
    [tempoDict setValue:self.planShareUser forKey:@"planShareUser"];
    [tempoDict setValue:self.planShareUserName forKey:@"planShareUserName"];
    [tempoDict setValue:self.planStatus forKey:@"planStatus"];
    [tempoDict setValue:self.planType forKey:@"planType"];
    [tempoDict setValue:self.sharedPlan forKey:@"sharedPlan"];
    [tempoDict setValue:self.totalMissions forKey:@"totalMissions"];
    NSMutableArray *newMissionList = [[NSMutableArray alloc] init];
    for (Mission *newMission in self.missions) {
        [newMissionList addObject:newMission.transToDictionary];
    }
    [tempoDict setValue:newMissionList forKey:@"missions"];
    return tempoDict;
}


@end
