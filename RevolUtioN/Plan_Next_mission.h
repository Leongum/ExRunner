//
//  Plan_Next_mission.h
//  Cyberace
//
//  Created by leon on 13-11-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Plan.h"
#import "Mission.h"
#import "Plan_Run_History.h"

@interface Plan_Next_mission : NSManagedObject

@property (nonatomic, retain) NSNumber * planId;
@property (nonatomic, retain) NSNumber * nextMissionId;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * planRunUuid;

@property (nonatomic, retain) Plan * planInfo;

@property (nonatomic, retain) Mission * nextMission;

@property (nonatomic, retain) Plan_Run_History * history;

+(Plan_Next_mission *) intiUnassociateEntity;

+(Plan_Next_mission *) removeAssociateForEntity:(Plan_Next_mission *)associatedEntity;

@end
