//
//  Mission.m
//  RevolUtioN
//
//  Created by leon on 13828.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "Mission.h"
#import "RORDBCommon.h"
#import "Mission_Challenge.h"
#import "Place_Package.h"

@implementation Mission

@dynamic challengeId;
@dynamic cycleTime;
@dynamic experience;
@dynamic lastUpdateTime;
@dynamic levelLimited;
@dynamic missionContent;
@dynamic missionDistance;
@dynamic missionFlag;
@dynamic missionFrom;
@dynamic missionId;
@dynamic missionName;
@dynamic missionPackageId;
@dynamic missionPlacePackageId;
@dynamic missionSpeed;
@dynamic missionSteps;
@dynamic missionTime;
@dynamic missionTo;
@dynamic missionTypeId;
@dynamic scores;
@dynamic sequence;
@dynamic subMissionList;
@dynamic planId;


//array list for place package, challenge, submission
@synthesize missionPlacePackageList;
@synthesize challengeList;
@synthesize subMissionPackageList;

+(Mission *) removeAssociateForEntity:(Mission *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Mission" inManagedObjectContext:context];
    Mission *unassociatedEntity = [[Mission alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    NSMutableArray *challengLists = [[NSMutableArray alloc] init];
    for (Mission_Challenge *missionChallenge in associatedEntity.challengeList) {
        [challengLists addObject:[Mission_Challenge removeAssociateForEntity:missionChallenge]];
    }
    unassociatedEntity.challengeList = [challengLists copy];
    NSMutableArray *missionPlacePackageLists = [[NSMutableArray alloc] init];
    for (Place_Package *placePack in associatedEntity.missionPlacePackageList) {
        [missionPlacePackageLists addObject:[Place_Package removeAssociateForEntity:placePack]];
    }
    unassociatedEntity.missionPlacePackageList = [missionPlacePackageLists copy];
    NSMutableArray *subMissionPackageLists = [[NSMutableArray alloc] init];
    for (Mission *subMission in associatedEntity.subMissionPackageList) {
        [subMissionPackageLists addObject:[Mission removeAssociateForEntity:subMission]];
    }
    unassociatedEntity.subMissionPackageList = [subMissionPackageLists copy];
    return unassociatedEntity;
}

-(void)initWithDictionary:(NSDictionary *)dict{
    self.missionId = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionId"]];
    self.missionName = [RORDBCommon getStringFromId:[dict valueForKey:@"missionName"]];
    self.missionFrom = [RORDBCommon getStringFromId:[dict valueForKey:@"missionFrom"]];
    self.missionTypeId = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionTypeId"]];
    self.missionContent = [RORDBCommon getStringFromId:[dict valueForKey:@"missionContent"]];
    self.missionTo = [RORDBCommon getStringFromId:[dict valueForKey:@"missionTo"]];
    self.scores = [RORDBCommon getNumberFromId:[dict valueForKey:@"scores"]];
    self.experience = [RORDBCommon getNumberFromId:[dict valueForKey:@"experience"]];
    self.missionFlag = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionFlag"]];
    self.levelLimited = [RORDBCommon getNumberFromId:[dict valueForKey:@"levelLimited"]];
    self.missionTime = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionTime"]];
    self.missionDistance = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionDistance"]];
    self.cycleTime = [RORDBCommon getNumberFromId:[dict valueForKey:@"cycleTime"]];
    self.missionPlacePackageId = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionPlacePackageId"]];
    self.missionSteps = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionSteps"]];
    self.missionSpeed = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionSpeed"]];
    self.challengeId = [RORDBCommon getNumberFromId:[dict valueForKey:@"challengeId"]];
    self.subMissionList = [RORDBCommon getStringFromId:[dict valueForKey:@"subMissionList"]];
    self.missionPackageId = [RORDBCommon getNumberFromId:[dict valueForKey:@"missionPackageId"]];
    self.sequence = [RORDBCommon getNumberFromId:[dict valueForKey:@"sequence"]];
    self.lastUpdateTime = [RORDBCommon getDateFromId:[dict valueForKey:@"lastUpdateTime"]];
    self.planId = [RORDBCommon getNumberFromId:[dict valueForKey:@"planId"]];
}

-(NSMutableDictionary *)transToDictionary{
    NSMutableDictionary *tempoDict = [[NSMutableDictionary alloc] init];
    [tempoDict setValue:self.missionId forKey:@"missionId"];
    [tempoDict setValue:self.missionName forKey:@"missionName"];
    [tempoDict setValue:self.missionFrom forKey:@"missionFrom"];
    [tempoDict setValue:self.missionTypeId forKey:@"missionTypeId"];
    [tempoDict setValue:self.missionContent forKey:@"missionContent"];
    [tempoDict setValue:self.missionTo forKey:@"missionTo"];
    [tempoDict setValue:self.scores forKey:@"scores"];
    [tempoDict setValue:self.experience forKey:@"experience"];
    [tempoDict setValue:self.missionFlag forKey:@"missionFlag"];
    [tempoDict setValue:self.levelLimited forKey:@"levelLimited"];
    [tempoDict setValue:self.missionTime forKey:@"missionTime"];
    [tempoDict setValue:self.missionDistance forKey:@"missionDistance"];
    [tempoDict setValue:self.cycleTime forKey:@"cycleTime"];
    [tempoDict setValue:self.missionPlacePackageId forKey:@"missionPlacePackageId"];
    [tempoDict setValue:self.missionSteps forKey:@"missionSteps"];
    [tempoDict setValue:self.missionSpeed forKey:@"missionSpeed"];
    [tempoDict setValue:self.challengeId forKey:@"challengeId"];
    [tempoDict setValue:self.subMissionList forKey:@"subMissionList"];
    [tempoDict setValue:self.missionPackageId forKey:@"missionPackageId"];
    [tempoDict setValue:self.sequence forKey:@"sequence"];
    [tempoDict setValue:[RORDBCommon getStringFromId:self.lastUpdateTime] forKey:@"lastUpdateTime"];
    [tempoDict setValue:self.planId forKey:@"planId"];
    return tempoDict;
}

@end
