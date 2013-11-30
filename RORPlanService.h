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
#import "RORDBCommon.h"


@interface RORPlanService : NSObject

//根据planId问服务器同步最新的plan，存储到本地。并返回这个plan的详细信息
+(Plan *)syncPlan:(NSNumber *) planId;

//从本地数据库根据某个planID拿取某个plan
+(Plan *)fetchPlan:(NSNumber *) planId;

//根据pageNo获取对应page的plan。（已排序，不存入数据库，每次都问服务器拿）
+(NSMutableArray *)getTopPlansList:(NSNumber *) pageNo;

//传入本地需要建立的plan的信息，主要把plan.missionList填写一下。上传服务器，并返回新建好的plan
//并且加入收藏。
+(Plan *)createSelfPlan:(Plan *) plan;

//新建，更新收藏信息
+(void)updatePlanCollect:(Plan_Collect *) planCollect;

//根据用户ID获取用户最后正在执行的计划（最后一次更新的记录，可能是正在执行，完成，或者取消掉的记录），不存入本地数据库，每次都问服务器要。
+(Plan_Run_History *)getUserLastUpdatePlan:(NSNumber *) userId;

//根据planID，和pageNo获取 某个计划正在执行的人的进度（已排序，不存入数据库，每次都问服务器拿）
+(NSMutableArray *)getTopUsingByPlanId:planId withPageNo:(NSNumber *) pageNo;

//根据userId和pageNo获取用户好友列表中正在执行的plan的用户的执行情况(已排序，不存入数据库，每次都问服务器拿)
+(NSMutableArray *)getTopUsingByUserId:userId withPageNo:(NSNumber *) pageNo;

//问服务器获取收藏列表，存入本地数据库。仅在登录或者手动需要同步的时候调用
+(BOOL)syncUserCollect:(NSNumber *) userId;

//根据userId获取用户的收藏列表，本地数据库，仅支持登录用户获取自己的数据
+(NSMutableArray *)fetchPlanCollect:(NSNumber *) userId;

//上传本地新增的收藏plan数据，仅在手动同步和loading页面需要调用。（新增，更新已调用过）
+(BOOL)upLoadUserCollect:(NSNumber *) userId;

//获取好友关系数据。
+(Plan_User_Follow *)fetchUserFollow:(NSNumber *) userId withFollowerId:(NSNumber *) followerId;

//新建，更新用户关注列表
+(void)updateUserFollow:(Plan_User_Follow *) userFollow;

//问服务器获取关注列表，存入本地数据库。仅在登录或者手动需要同步的时候调用
+(BOOL)syncUserFollow:(NSNumber *) userId;

//上传本地新增的关注数据，仅在手动同步和loading页面需要调用。（新增，更新已调用过）
+(BOOL)upLoadUserFollow:(NSNumber *) userId;

//问服务器获取plan历史记录列表，存入本地数据库。仅在登录或者手动需要同步的时候调用
+(BOOL)syncUserPlanHistory:(NSNumber *) userId;

//上传本地新增和跟增的历史记录数据，仅在手动同步和loading页面需要调用。（新增，更新已调用过）
+(BOOL)upLoadUserPlanHistory:(NSNumber *) userId;

//获取用户需要执行的plan计划中的下一个mission。（Plan_next_mission 包含plan的信息，mission的信息，和当前planhistory的信息）
+(Plan_Next_mission *)fetchUserRunningPlanHistory;

//根据planId新增一个执行计划，执行之前需自己确定用户有没有别的正在执行的计划，此方法不含判断。返回Plan_next_mission
+(Plan_Next_mission *)startNewPlan:(NSNumber *) planId;

//当前计划的当前任务完成，进入计划的下一个Mission，返回Plan_next_mission
+(Plan_Next_mission *)gotoNextMission:(NSString *) planRunuuid;

//终止某一个运动计划。
+(BOOL)cancelCurrentPlan:(NSString *) planRunuuid;

//根据planRunUuid获取具体history信息，包含 所有的跑步记录。Plan_Run_History.runHistoryList
+(Plan_Run_History *)fetchUserPlanHistoryDetails:(NSString *) planRunUuid;

//根据userId获取用户的历史计划执行情况，仅支持登录用户获取自己的数据
+(NSMutableArray *)fetchUserPlanHistoryList:(NSNumber *) userId;

@end
