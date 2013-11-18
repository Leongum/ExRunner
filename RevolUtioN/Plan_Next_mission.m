//
//  Plan_Next_mission.m
//  Cyberace
//
//  Created by leon on 13-11-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "Plan_Next_mission.h"
#import "RORDBCommon.h"

@implementation Plan_Next_mission

@dynamic planId;
@dynamic nextMissionId;
@dynamic startTime;
@dynamic endTime;
@dynamic planRunUuid;

@synthesize planInfo;
@synthesize nextMission;
@synthesize history;

+(Plan_Next_mission *) intiUnassociateEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Plan_Next_mission" inManagedObjectContext:context];
    Plan_Next_mission *unassociatedEntity = [[Plan_Next_mission alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    return unassociatedEntity;
}

+(Plan_Next_mission *) removeAssociateForEntity:(Plan_Next_mission *)associatedEntity{
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Plan_Next_mission" inManagedObjectContext:context];
    Plan_Next_mission *unassociatedEntity = [[Plan_Next_mission alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    for (NSString *attr in [[entity attributesByName] allKeys]) {
        [unassociatedEntity setValue:[associatedEntity valueForKey:attr] forKey:attr];
    }
    unassociatedEntity.planInfo = [Plan removeAssociateForEntity:associatedEntity.planInfo];
    unassociatedEntity.nextMission = [Mission removeAssociateForEntity:associatedEntity.nextMission];
    unassociatedEntity.history = [Plan_Run_History removeAssociateForEntity:associatedEntity.history];
    return unassociatedEntity;
}

@end
