//
//  RORMissionServices.h
//  RevolUtioN
//
//  Created by leon on 13-7-21.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORAppDelegate.h"
#import "RORHttpResponse.h"
#import "RORMissionClientHandler.h"
#import "Mission.h"
#import "Mission_Type.h"
#import "Place_Package.h"
#import "RORContextUtils.h"

@interface RORMissionServices : NSObject

+(Mission *)fetchMission:(NSNumber *) missionId;

+(Mission *)fetchMission:(NSNumber *) missionId withContext:(BOOL) needContext;

+(NSMutableArray *)fetchMissionListByPlanId:(NSNumber *) planId withContext:(BOOL) needContext;

+(NSArray *)fetchMissionList:(MissionTypeEnum *) missionType;

+ (BOOL)syncMissions;

@end
