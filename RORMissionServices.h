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

+(NSArray *)fetchMissionList:(MissionTypeEnum *) missionType;

+ (Boolean)syncMissions;

@end
