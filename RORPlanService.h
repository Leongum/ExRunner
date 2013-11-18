//
//  RORPlanService.h
//  Cyberace
//
//  Created by leon on 13-11-15.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Plan.h"
#import "Plan_Collect.h"
#import "Plan_Next_mission.h"
#import "Plan_Run_History.h"
#import "Plan_User_Follow.h"
#import "Plan_Next_mission.h"
#import "RORHttpResponse.h"
#import "RORUserClientHandler.h"
#import "RORUtils.h"
#import "RORPlanClientHandler.h"
#import "RORUserUtils.h"
#import "Mission.h"
#import "RORMissionServices.h"
#import "RORConstant.h"
#import "RORRunHistoryServices.h"

@interface RORPlanService : NSObject

+(Plan *)syncPlan:(NSNumber *) planId;

+(NSMutableArray *)getTopPlansList:(NSNumber *) pageNo;

+(BOOL)createSelfPlan:(Plan *) plan;

+(void)updatePlanCollect:(Plan_Collect *) planCollect;

+(Plan_Run_History *)getUserLastUpdatePlan:(NSNumber *) userId;

+(NSMutableArray *)getTopUsingByPlanId:planId withPageNo:(NSNumber *) pageNo;

+(NSMutableArray *)getTopUsingByUserId:userId withPageNo:(NSNumber *) pageNo;

+(BOOL)syncUserCollect:(NSNumber *) userId;

+(NSMutableArray *)fetchPlanCollect:(NSNumber *) userId;

+(BOOL)upLoadUserCollect:(NSNumber *) userId;

+(void)updateUserFollow:(Plan_User_Follow *) userFollow;

+(BOOL)syncUserFollow:(NSNumber *) userId;

+(BOOL)upLoadUserFollow:(NSNumber *) userId;

+(BOOL)syncUserPlanHistory:(NSNumber *) userId;

+(BOOL)upLoadUserPlanHistory:(NSNumber *) userId;

+(Plan_Next_mission *)fetchUserRunningPlanHistory;

+(Plan_Next_mission *)startNewPlan:(NSNumber *) planId;

+(Plan_Next_mission *)gotoNextMission:(NSString *) planRunuuid;

+(BOOL)cancelCurrentPlan:(NSString *) planRunuuid;

+(Plan_Run_History *)fetchUserPlanHistoryDetails:(NSString *) planRunUuid;

+(NSMutableArray *)fetchUserPlanHistoryList:(NSNumber *) userId;

@end
