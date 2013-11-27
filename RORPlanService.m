//
//  RORPlanService.m
//  Cyberace
//
//  Created by leon on 13-11-15.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORPlanService.h"

@implementation RORPlanService

+(Plan *)syncPlan:(NSNumber *) planId{
    Plan *plan = [self fetchPlan:planId withMissions:NO withContext:YES];
    NSString *lastUpdateTime = @"2000-01-01 00:00:00";
    if(plan != nil && plan.lastUpdateTime != nil){
        lastUpdateTime = [RORUtils getStringFromDate:plan.lastUpdateTime];
    }
    NSError *error = nil;
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    RORHttpResponse *httpResponse =[RORPlanClientHandler syncPlan:planId withLastUpdateTime:lastUpdateTime];
    if ([httpResponse responseStatus] == 200){
        NSDictionary *planDic = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        
        NSArray *missionsDicList = [planDic valueForKey:@"missions"];
        if(plan == nil)
            plan = [NSEntityDescription insertNewObjectForEntityForName:@"Plan" inManagedObjectContext:context];
        [plan initWithDictionary:planDic];
        [plan setValue:[RORUserUtils getSystemTime] forKey:@"lastUpdateTime"];
        
        NSMutableArray *missions = [[NSMutableArray alloc] init];
        for (NSDictionary *missionDict in missionsDicList){
            NSNumber *missionIdNum = [missionDict valueForKey:@"missionId"];
            Mission *missionEntity = [RORMissionServices fetchMission: missionIdNum withContext:YES];
            if(missionEntity == nil)
                missionEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Mission" inManagedObjectContext:context];
            [missionEntity initWithDictionary:missionDict];
            [missions addObject:missionEntity];
        }
        
        [RORContextUtils saveContext];
        plan.missionList = missions;
        [Plan removeAssociateForEntity:plan];
        return plan;
    } else {
        NSLog(@"sync with host error. Status Code: %d", [httpResponse responseStatus]);
    }
    return plan;
}

+(Plan *)fetchPlan:(NSNumber *) planId{
    return [self fetchPlan:planId withMissions:YES withContext:NO];
}

+(Plan *)fetchPlan:(NSNumber *) planId withMissions:(BOOL) needMissionDetail withContext:(BOOL) needContext{
    NSString *table=@"Plan";
    NSString *query = @"planId = %@";
    NSArray *params = [NSArray arrayWithObjects:planId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    Plan *plan = (Plan *) [fetchObject objectAtIndex:0];
    
    if(!needContext){
        plan = [Plan removeAssociateForEntity:plan];
    }
    if(needMissionDetail){
    plan.missionList = [RORMissionServices fetchMissionListByPlanId:planId withContext:needContext];
    }
    return plan;
}

+(Plan *)createSelfPlan:(Plan *) plan{
    if([RORUserUtils getUserId].integerValue >0){
        plan.planShareUser = [RORUserUtils getUserId];
        plan.planShareUserName = [RORUserUtils getUserName];
        plan.planStatus = [NSNumber numberWithInt:(int)PlanStatusEnabled];
        plan.sharedPlan = [NSNumber numberWithInt:(int)SharedPlanShared];
        if(plan.planType.integerValue == (int)PlanTypeComplex){
            plan.totalMissions = [NSNumber numberWithInt:[plan.missionList count]];
        }else if(plan.planType.integerValue == (int)PlanTypeEasy){
            plan.totalMissions = [NSNumber numberWithInt:(plan.durationLast.integerValue/plan.duration.integerValue) * plan.cycleTime.integerValue];
        }
        
        NSMutableDictionary  *plandic = [plan transToDictionary];
        NSError *error = nil;
        NSManagedObjectContext *context = [RORContextUtils getShareContext];
        RORHttpResponse *httpResponse =[RORPlanClientHandler createSelfPlan:[RORUserUtils getUserId] withPlan:plandic];
        if ([httpResponse responseStatus] == 200){
            NSDictionary *planDic = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
            
            NSArray *missionsDicList = [planDic valueForKey:@"missions"];
            plan = [NSEntityDescription insertNewObjectForEntityForName:@"Plan" inManagedObjectContext:context];
            [plan initWithDictionary:planDic];
            
            NSMutableArray *missions = [[NSMutableArray alloc] init];
            for (NSDictionary *missionDict in missionsDicList){
                NSNumber *missionIdNum = [missionDict valueForKey:@"missionId"];
                Mission *missionEntity = [RORMissionServices fetchMission: missionIdNum withContext:YES];
                if(missionEntity == nil)
                    missionEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Mission" inManagedObjectContext:context];
                [missionEntity initWithDictionary:missionDict];
                [missions addObject:missionEntity];
            }
            plan.missionList = missions;
            [Plan removeAssociateForEntity:plan];
            
            //add plan to collect
            Plan_Collect *planCollect = [NSEntityDescription insertNewObjectForEntityForName:@"Plan_Collect" inManagedObjectContext:context];
            planCollect.userId = [RORUserUtils getUserId];
            planCollect.planId = plan.planId;
            planCollect.updated = [NSNumber numberWithInt:1];
            planCollect.collectStatus = [NSNumber numberWithInt:(int)CollectStatusCollected];
            planCollect.collectTime =[RORUserUtils getSystemTime];
            
            [RORContextUtils saveContext];
            
            //update user collect
            [self upLoadUserCollect:[RORUserUtils getUserId]];
            return plan;
        } else {
            NSLog(@"sync with host error. Status Code: %d", [httpResponse responseStatus]);
        }
    }
    return nil;
}

+(void)updatePlanCollect:(Plan_Collect *) planCollect {
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    Plan_Collect *planCollectEntity = [self fetchPlanCollect:planCollect.userId withPlanId:planCollect.planId withContext:YES];
    if(planCollectEntity == nil)
        planCollectEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Plan_Collect" inManagedObjectContext:context];
    planCollectEntity.planId = planCollect.planId;
    planCollectEntity.userId = planCollect.userId;
    planCollectEntity.collectTime = [RORUserUtils getSystemTime];
    planCollectEntity.updated = [NSNumber numberWithInt:1];
    planCollectEntity.collectStatus = planCollect.collectStatus;
    NSLog(@"%@", planCollectEntity);
    [RORContextUtils saveContext];
    if([RORUserUtils getUserId].integerValue > 0){
        [self upLoadUserCollect:[RORUserUtils getUserId]];
    }
}

+(Plan_Collect *)fetchPlanCollect:(NSNumber *) userId withPlanId:(NSNumber *) planId withContext:(BOOL) needContext{
    NSString *table=@"Plan_Collect";
    NSString *query = @"userId = %@ and planId = %@";
    NSArray *params = [NSArray arrayWithObjects: userId, planId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    Plan_Collect *planCollect = (Plan_Collect *) [fetchObject objectAtIndex:0];
    if(!needContext){
        planCollect = [Plan_Collect removeAssociateForEntity:planCollect];
    }
    return planCollect;
}

+(BOOL)syncUserCollect:(NSNumber *) userId{
    NSError *error = nil;
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"UserCollectUpdateTime"];
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    RORHttpResponse *httpResponse =[RORPlanClientHandler getUserCollect:userId withLastUpdateTime:lastUpdateTime];
    if ([httpResponse responseStatus] == 200){
        NSArray *userCollectList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *userCollectDict in userCollectList){
            NSNumber *userIdNum = [userCollectDict valueForKey:@"userId"];
            NSNumber *planIdNum = [userCollectDict valueForKey:@"planId"];
            Plan_Collect *userCollectEntity = [self fetchPlanCollect:userIdNum withPlanId:planIdNum withContext:YES];
            if(userCollectEntity == nil)
                userCollectEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Plan_Collect" inManagedObjectContext:context];
            [userCollectEntity initWithDictionary:userCollectDict];
        }
        [RORContextUtils saveContext];
        [RORUserUtils saveLastUpdateTime:@"UserCollectUpdateTime"];
        return YES;
    } else {
        NSLog(@"sync with host error. Status Code: %d", [httpResponse responseStatus]);
    }
    return NO;
}

+(NSMutableArray *)fetchPlanCollect:(NSNumber *) userId{
    NSString *table=@"Plan_Collect";
    NSString *query = @"userId = %@ and collectStatus = 0";
    NSArray *params = [NSArray arrayWithObjects: userId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    NSMutableArray *planLists = [NSMutableArray arrayWithCapacity:10];
    for (Plan_Collect *planCollect in fetchObject) {
        Plan *plan = [self fetchPlan:planCollect.planId withMissions:NO withContext:NO];
        [planLists addObject:plan];
    }
    return planLists;
}

+(NSArray *)fetchUnsyncedPlanCollect:(NSNumber *) userId{
    NSString *table=@"Plan_Collect";
    NSString *query = @"userId = %@ and updated = 1";
    NSArray *params = [NSArray arrayWithObjects: userId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    return fetchObject;
}

+(BOOL)upLoadUserCollect:(NSNumber *) userId{
    NSArray *planUnSyncedCollect = [self fetchUnsyncedPlanCollect:userId];
    if([planUnSyncedCollect count] > 0 && [RORUserUtils getUserId].integerValue > 0){
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (Plan_Collect *planCollect in planUnSyncedCollect) {
            [array addObject:planCollect.transToDictionary];
        }
        RORHttpResponse *httpResponse =[RORPlanClientHandler putUserCollects:userId withUserCollect:array];
        if ([httpResponse responseStatus] == 200){
            for (Plan_Collect *info in planUnSyncedCollect) {
                info.updated = [NSNumber numberWithInt:1];
            }
            [RORContextUtils saveContext];
            return YES;
        } else {
            NSLog(@"sync with host error. Status Code: %d", [httpResponse responseStatus]);
        }
        return NO;
    }
    return YES;
}


+(void)updateUserFollow:(Plan_User_Follow *) userFollow {
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    Plan_User_Follow *userFollowEntity = [self fetchUserFollow:userFollow.userId withFollowerId:userFollow.followerUserId withContext:YES];
    if(userFollowEntity == nil)
        userFollowEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Plan_User_Follow" inManagedObjectContext:context];
    userFollowEntity.userId = userFollow.userId;
    userFollowEntity.followerUserId = userFollow.followerUserId;
    userFollowEntity.addTime = [RORUserUtils getSystemTime];
    userFollowEntity.updated = [NSNumber numberWithInt:1];
    userFollowEntity.status = userFollow.status;
    
    [RORContextUtils saveContext];
    if([RORUserUtils getUserId].integerValue > 0){
        [self upLoadUserCollect:[RORUserUtils getUserId]];
    }
}

+(Plan_User_Follow *)fetchUserFollow:(NSNumber *) userId withFollowerId:(NSNumber *) followerId withContext:(BOOL) needContext{
    NSString *table=@"Plan_User_Follow";
    NSString *query = @"userId = %@ and followerUserId = %@";
    NSArray *params = [NSArray arrayWithObjects: userId, followerId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    Plan_User_Follow *userFollower = (Plan_User_Follow *) [fetchObject objectAtIndex:0];
    if(!needContext){
        userFollower = [Plan_User_Follow removeAssociateForEntity:userFollower];
    }
    return userFollower;
}

+(BOOL)syncUserFollow:(NSNumber *) userId{
    NSError *error = nil;
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"UserFollowUpdateTime"];
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    RORHttpResponse *httpResponse =[RORPlanClientHandler getUserFollow:userId withLastUpdateTime:lastUpdateTime];
    if ([httpResponse responseStatus] == 200){
        NSArray *userFollowList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *userFollowDict in userFollowList){
            NSNumber *userIdNum = [userFollowDict valueForKey:@"userId"];
            NSNumber *followUserIdNum = [userFollowDict valueForKey:@"followerUserId"];
            Plan_User_Follow *userFollowEntity = [self fetchUserFollow:userIdNum withFollowerId:followUserIdNum withContext:YES];
            if(userFollowEntity == nil)
                userFollowEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Plan_User_Follow" inManagedObjectContext:context];
            [userFollowEntity initWithDictionary:userFollowDict];
        }
        [RORContextUtils saveContext];
        [RORUserUtils saveLastUpdateTime:@"UserFollowUpdateTime"];
        return YES;
    } else {
        NSLog(@"sync with host error. Status Code: %d", [httpResponse responseStatus]);
    }
    return NO;
}

+(NSArray *)fetchUnsyncedUserFollow:(NSNumber *) userId{
    NSString *table=@"Plan_User_Follow";
    NSString *query = @"userId = %@ and updated = 1";
    NSArray *params = [NSArray arrayWithObjects: userId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    return fetchObject;
}

+(BOOL)upLoadUserFollow:(NSNumber *) userId{
    NSArray *followUnSyncedCollect = [self fetchUnsyncedUserFollow:userId];
    if([followUnSyncedCollect count] > 0 && [RORUserUtils getUserId].integerValue > 0){
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (Plan_User_Follow *userFollow in followUnSyncedCollect) {
            [array addObject:userFollow.transToDictionary];
        }
        RORHttpResponse *httpResponse =[RORPlanClientHandler putUserFollows:userId withUserFollows:array];
        if ([httpResponse responseStatus] == 200){
            for (Plan_User_Follow *info in followUnSyncedCollect) {
                info.updated = [NSNumber numberWithInt:1];
            }
            [RORContextUtils saveContext];
            return YES;
        } else {
            NSLog(@"sync with host error. Status Code: %d", [httpResponse responseStatus]);
        }
        return NO;
    }
    return YES;
}

+(NSMutableArray *)fetchUserPlanHistoryList:(NSNumber *) userId{
    NSString *table=@"Plan_Run_History";
    NSString *query = @"userId = %@";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lastUpdateTime" ascending:NO];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    NSMutableArray *planHistories = [NSMutableArray arrayWithCapacity:10];
    for(Plan_Run_History *planHistory in fetchObject){
        [planHistories addObject:[Plan_Run_History removeAssociateForEntity:planHistory]];
    }
    return planHistories;
}

+(Plan_Run_History *)fetchUserPlanHistoryDetails:(NSString *) planRunUuid{
    return [self fetchUserPlanHistory:planRunUuid withHistoryDetail:YES withContext:NO];
}

+(Plan_Run_History *)fetchUserPlanHistory:(NSString *) planRunUuid withHistoryDetail:(BOOL) needHistoryDetail withContext:(BOOL) needContext{
    NSString *table=@"Plan_Run_History";
    NSString *query = @"planRunUuid = %@";
    NSArray *params = [NSArray arrayWithObjects: planRunUuid, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    Plan_Run_History *userPlanHistory = (Plan_Run_History *) [fetchObject objectAtIndex:0];
    if(needHistoryDetail){
        userPlanHistory.runHistoryList = [[RORRunHistoryServices fetchRunHistoryByPlanRunUuid:userPlanHistory.planRunUuid] mutableCopy];
    }
    if(!needContext){
        userPlanHistory = [Plan_Run_History removeAssociateForEntity:userPlanHistory];
    }
    return userPlanHistory;
}

+(BOOL)syncUserPlanHistory:(NSNumber *) userId{
    NSError *error = nil;
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"UserPlanHistoryUpdateTime"];
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    RORHttpResponse *httpResponse =[RORPlanClientHandler getUserPlanHistory:userId withLastUpdateTime:lastUpdateTime];
    if ([httpResponse responseStatus] == 200){
        NSArray *userPlanHistoryList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *userPlanHistoryDict in userPlanHistoryList){
            NSString *planRunUuid = [userPlanHistoryDict valueForKey:@"planRunUuid"];
            Plan_Run_History *userPlanHistoryEntity = [self fetchUserPlanHistory:planRunUuid withHistoryDetail:NO withContext:YES];
            if(userPlanHistoryEntity != nil && userPlanHistoryEntity.operate != nil){
                continue;
            }
            if(userPlanHistoryEntity == nil)
                userPlanHistoryEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Plan_Run_History" inManagedObjectContext:context];
            [userPlanHistoryEntity initWithDictionary:userPlanHistoryDict];
            if(userPlanHistoryEntity.historyStatus.integerValue == (int)HistoryStatusExecute){
                Plan_Next_mission *planNextMission = [self fetchPlanNextMission];
                if(planNextMission.planRunUuid != userPlanHistoryEntity.planRunUuid){
                    planNextMission.planId = userPlanHistoryEntity.planId;
                    planNextMission.planRunUuid = userPlanHistoryEntity.planRunUuid;
                    planNextMission.nextMissionId = userPlanHistoryEntity.nextMissionId;
                    NSDate *startTime = [NSDate date];
                    NSDate *endTime = [NSDate date];
                    NSLog(@"%@", userPlanHistoryEntity);
                    Plan *plan = [self fetchPlan:userPlanHistoryEntity.planId withMissions:YES withContext:NO];
                    if(plan== nil || plan.planId == nil){
                        plan = [self syncPlan:userPlanHistoryEntity.planId];
                    }
                    if(plan.planType.integerValue == PlanTypeEasy){
                        int timeScape = 0;
                        if(plan.durationType.integerValue == DurationTypeDay){
                            timeScape = plan.duration.integerValue/plan.cycleTime.integerValue * 86400;
                        }else if(plan.durationType.integerValue == DurationTypeWeek){
                            timeScape = (plan.duration.integerValue * 7)/plan.cycleTime.integerValue *86400;
                        }
                        endTime = [startTime dateByAddingTimeInterval:timeScape];
                    }else{
                        for(Mission *mission in plan.missionList){
                            if(mission.missionId.integerValue == userPlanHistoryEntity.nextMissionId.integerValue){
                                endTime = [startTime dateByAddingTimeInterval:mission.cycleTime.integerValue * 86400];
                            }
                        }
                    }
                    planNextMission.startTime = startTime;
                    planNextMission.endTime = endTime;
                }
            }
        }
        [RORContextUtils saveContext];
        [RORUserUtils saveLastUpdateTime:@"UserPlanHistoryUpdateTime"];
        return YES;
    } else {
        NSLog(@"sync with host error. Status Code: %d", [httpResponse responseStatus]);
    }
    return NO;
}


+(NSArray *)fetchUnsyncedUserPlanHistory:(NSNumber *) userId{
    NSString *table=@"Plan_Run_History";
    NSString *query = @"userId = %@ and operate != nil";
    NSArray *params = [NSArray arrayWithObjects: userId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    return fetchObject;
}

+(BOOL)upLoadUserPlanHistory:(NSNumber *) userId{
    NSArray *planHistoryUnSynced = [self fetchUnsyncedUserPlanHistory:userId];
    if([planHistoryUnSynced count] > 0 && [RORUserUtils getUserId].integerValue > 0){
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (Plan_Run_History *planHistory in planHistoryUnSynced) {
            [array addObject:planHistory.transToDictionary];
        }
        RORHttpResponse *httpResponse =[RORPlanClientHandler putUserPlanHistory:userId withPlanHistory:array];
        if ([httpResponse responseStatus] == 200){
            for (Plan_Run_History *info in planHistoryUnSynced) {
                info.operate = nil;
            }
            [RORContextUtils saveContext];
            return YES;
        } else {
            NSLog(@"sync with host error. Status Code: %d", [httpResponse responseStatus]);
        }
        return NO;
    }
    return YES;
}

+(Plan_Next_mission *)fetchUserRunningPlanHistory{
    NSString *table=@"Plan_Next_mission";
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:nil withPredicate:nil];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    Plan_Next_mission *planNextMission = [fetchObject objectAtIndex:0];
    if(planNextMission.nextMissionId == nil){
        return nil;
    }
    if(planNextMission.nextMissionId != nil){
        planNextMission.nextMission = [RORMissionServices fetchMission: planNextMission.nextMissionId withContext:YES];
    }
    if(planNextMission.planId != nil){
        planNextMission.planInfo = [self fetchPlan:planNextMission.planId withMissions:YES withContext:YES];
    }
    if(planNextMission.planRunUuid != nil){
        planNextMission.history = [self fetchUserPlanHistory:planNextMission.planRunUuid withHistoryDetail:YES withContext:YES];
    }
    [Plan_Next_mission removeAssociateForEntity:planNextMission];

    return planNextMission;
}

+(Plan_Next_mission *)fetchPlanNextMission{
    NSString *table=@"Plan_Next_mission";
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:nil withPredicate:nil];
    if (fetchObject == nil || [fetchObject count] == 0) {
        NSManagedObjectContext *context = [RORContextUtils getShareContext];
        return [NSEntityDescription insertNewObjectForEntityForName:@"Plan_Next_mission" inManagedObjectContext:context];;
    }
    return [fetchObject objectAtIndex:0];
}

+(Plan_Next_mission *)startNewPlan:(NSNumber *) planId{
    Plan *plan = [self fetchPlan:planId withMissions:YES withContext:NO];
    if(plan != nil && plan.planId != nil){
        NSManagedObjectContext *context = [RORContextUtils getShareContext];
        Plan_Run_History *planRunHistory = [NSEntityDescription insertNewObjectForEntityForName:@"Plan_Run_History" inManagedObjectContext:context];
        planRunHistory.planId = planId;
        planRunHistory.historyStatus = [NSNumber numberWithInt:(int)HistoryStatusExecute];
        planRunHistory.planRunUuid = [RORUtils uuidString];
        NSArray *missionsArray = [plan.missionIds componentsSeparatedByString:@","];
        NSNumber *nextMissionId = (NSNumber *)[missionsArray objectAtIndex:0];
        planRunHistory.remainingMissions = plan.totalMissions;
        planRunHistory.totalMissions = plan.totalMissions;
        planRunHistory.nextMissionId = nextMissionId;
        planRunHistory.lastUpdateTime = [RORUserUtils getSystemTime];
        planRunHistory.startTime = [NSDate date];
        planRunHistory.userId = [RORUserUtils getUserId];
        planRunHistory.operate = [NSNumber numberWithInt:(int)OperateInsert];
        Plan_Next_mission *planNextMission = [self fetchPlanNextMission];
        planNextMission.planId = planId;
        planNextMission.nextMissionId = nextMissionId;
        NSDate *startTime = [NSDate date];
        NSDate *endTime = [NSDate date];
        if(plan.planType.integerValue == PlanTypeEasy){
            int timeScape = 0;
            if(plan.durationType.integerValue == DurationTypeDay){
                timeScape = plan.duration.integerValue/plan.cycleTime.integerValue * 86400;
            }else if(plan.durationType.integerValue == DurationTypeWeek){
                timeScape = (plan.duration.integerValue * 7)/plan.cycleTime.integerValue *86400;
            }
            endTime = [startTime dateByAddingTimeInterval:timeScape];
        }else{
            for(Mission *mission in plan.missionList){
                if(mission.missionId.integerValue == nextMissionId.integerValue){
                    endTime = [startTime dateByAddingTimeInterval:mission.cycleTime.integerValue * 86400];
                }
            }
        }
        planNextMission.startTime = startTime;
        planNextMission.endTime = endTime;
        planNextMission.planRunUuid = planRunHistory.planRunUuid;
        [RORContextUtils saveContext];
        [self upLoadUserPlanHistory:[RORUserUtils getUserId]];
        return [self fetchUserRunningPlanHistory];
    }
    return nil;
}

+(Plan_Next_mission *)gotoNextMission:(NSString *) planRunuuid{
    Plan_Run_History *planHistory = [self fetchUserPlanHistory:planRunuuid withHistoryDetail:NO withContext:YES];
    if(planHistory != nil){
        Plan_Next_mission *planNextMission = [self fetchPlanNextMission];
        if(planHistory.remainingMissions.integerValue == 1){
            planHistory.remainingMissions = 0;
            planHistory.endTime = [NSDate date];
            planHistory.historyStatus =[NSNumber numberWithInt:(int)HistoryStatusFinished];
            planHistory.lastUpdateTime = [RORUserUtils getSystemTime];
            planHistory.nextMissionId = nil;
            planHistory.operate = [NSNumber numberWithInt:(int)OperateUpdate];
            planNextMission.nextMissionId = nil;
        }
        else{
            planHistory.remainingMissions = [NSNumber numberWithInt:(planHistory.remainingMissions.integerValue - 1)];
            planHistory.lastUpdateTime = [RORUserUtils getSystemTime];
            Plan *plan = [self fetchPlan:planHistory.planId withMissions:YES withContext:NO];
            NSArray *missionsArray = [plan.missionIds componentsSeparatedByString:@","];
            NSNumber *nextMissionId = planHistory.nextMissionId;
            NSDate *startTime = [NSDate date];
            NSDate *endTime = nil;
            if(plan.planType.integerValue == PlanTypeEasy){
                int timeScape = 0;
                
                if(plan.durationType.integerValue == DurationTypeDay){
                    timeScape = plan.duration.integerValue/plan.cycleTime.integerValue * 86400;
                }else if(plan.durationType.integerValue == DurationTypeWeek){
                    timeScape = (plan.duration.integerValue * 7)/plan.cycleTime.integerValue *86400;
                }
                endTime = [startTime dateByAddingTimeInterval:timeScape];
            }else{
                nextMissionId = (NSNumber *)[missionsArray objectAtIndex:(planHistory.totalMissions.integerValue - planHistory.remainingMissions.integerValue)];
                for(Mission *mission in plan.missionList){
                    if(mission.missionId.integerValue == nextMissionId.integerValue){
                        endTime = [startTime dateByAddingTimeInterval:mission.cycleTime.integerValue * 86400];
                    }
                }
            }
            planHistory.nextMissionId = nextMissionId;
            planHistory.operate = [NSNumber numberWithInt:(int)OperateUpdate];
            planNextMission.nextMissionId = nextMissionId;
            planNextMission.startTime = startTime;
            planNextMission.endTime = endTime;
            
        }
        [RORContextUtils saveContext];
        [self upLoadUserPlanHistory:[RORUserUtils getUserId]];
        return [self fetchUserRunningPlanHistory];
    }
    return nil;
}

+(BOOL)cancelCurrentPlan:(NSString *) planRunuuid{
    Plan_Run_History *planHistory = [self fetchUserPlanHistory:planRunuuid withHistoryDetail:NO withContext:YES];
    if(planHistory != nil){
        Plan_Next_mission *planNextMission = [self fetchPlanNextMission];
        planHistory.endTime = [NSDate date];
        planHistory.historyStatus =[NSNumber numberWithInt:(int)HistoryStatusCancled];
        planHistory.lastUpdateTime = [RORUserUtils getSystemTime];
        planHistory.nextMissionId = nil;
        planHistory.operate = [NSNumber numberWithInt:(int)OperateUpdate];
        planNextMission.nextMissionId = nil;
        [RORContextUtils saveContext];
        [self upLoadUserPlanHistory:[RORUserUtils getUserId]];
        return YES;
    }
    return NO;
}

+(Plan_Run_History *)getUserLastUpdatePlan:(NSNumber *) userId{
    NSError *error = nil;
    RORHttpResponse *httpResponse =[RORPlanClientHandler getUserLastUpdatingPlan:userId];
    if ([httpResponse responseStatus] == 200){
        NSDictionary *planHistoryDic = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        Plan_Run_History *excutingPlan = [Plan_Run_History intiUnassociateEntity];
        [excutingPlan initWithDictionary:planHistoryDic];
        return excutingPlan;
    } else {
        NSLog(@"sync with host error. Status Code: %d", [httpResponse responseStatus]);
    }
    return nil;
}

+(NSMutableArray *)getTopUsingByPlanId:planId withPageNo:(NSNumber *) pageNo{
    NSError *error = nil;
    RORHttpResponse *httpResponse =[RORPlanClientHandler getPlanUsingListByPlanId:planId withPageNo:pageNo];
    NSMutableArray *plans = [[NSMutableArray alloc] init];
    if ([httpResponse responseStatus] == 200){
        NSArray *planList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *planDict in planList){
            Plan *plan = [Plan intiUnassociateEntity];
            [plan initWithDictionary:planDict];
            [plans addObject:plan];
        }
    } else {
        NSLog(@"sync with host error Status Code: %d", [httpResponse responseStatus]);
    }
    return plans;
}

+(NSMutableArray *)getTopUsingByUserId:userId withPageNo:(NSNumber *) pageNo{
    NSError *error = nil;
    RORHttpResponse *httpResponse =[RORPlanClientHandler getPlanUsingListByUserId:userId withPageNo:pageNo];
    NSMutableArray *plans = [[NSMutableArray alloc] init];
    if ([httpResponse responseStatus] == 200){
        NSArray *planList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *planDict in planList){
            Plan *plan = [Plan intiUnassociateEntity];
            [plan initWithDictionary:planDict];
            [plans addObject:plan];
        }
    } else {
        NSLog(@"sync with host error. Status Code: %d", [httpResponse responseStatus]);
    }
    return plans;
}

+(NSMutableArray *)getTopPlansList:(NSNumber *) pageNo{
    NSError *error = nil;
    RORHttpResponse *httpResponse =[RORPlanClientHandler getPlansList:pageNo];
    NSMutableArray *plans = [[NSMutableArray alloc] init];
    if ([httpResponse responseStatus] == 200){
        NSArray *planList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *planDict in planList){
            Plan *plan = [Plan intiUnassociateEntity];
            [plan initWithDictionary:planDict];
            [plans addObject:plan];
        }
    } else {
        NSLog(@"sync with host error. Status Code: %d", [httpResponse responseStatus]);
    }
    return plans;
}
@end
