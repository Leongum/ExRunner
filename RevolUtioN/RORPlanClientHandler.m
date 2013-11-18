//
//  RORPlanClientHandler.m
//  Cyberace
//
//  Created by leon on 13-11-15.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORPlanClientHandler.h"

@implementation RORPlanClientHandler

+(RORHttpResponse *)syncPlan:(NSNumber *) planId withLastUpdateTime:(NSString *) lastUpdateTime{
    NSString *url = [NSString stringWithFormat:PLAN_INFO_URL ,planId, lastUpdateTime];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)getPlansList:(NSNumber *) pageNo{
    NSString *url = [NSString stringWithFormat:HOT_PLAN_URL ,pageNo];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)createSelfPlan:userId withPlan:(NSMutableDictionary *) planDic{
    NSString *url = [NSString stringWithFormat:POST_PLAN_URL,userId];
    RORHttpResponse *httpResponse = [RORHttpClientHandler postRequest:url withRequstBody:[RORUtils toJsonFormObject:planDic]];
    return httpResponse;
}

+(RORHttpResponse *)getUserCollect:(NSNumber *) userId withLastUpdateTime:(NSString *) lastUpdateTime{
    NSString *url = [NSString stringWithFormat:USER_COLLECT_PLAN_URL ,userId, lastUpdateTime];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)putUserCollects:userId withUserCollect:(NSMutableArray *) userCollects{
    NSString *url = [NSString stringWithFormat:PUT_USER_COLLECT_PLAN_URL,userId];
    RORHttpResponse *httpResponse = [RORHttpClientHandler putRequest:url withRequstBody:[RORUtils toJsonFormObject:userCollects]];
    return httpResponse;
}

+(RORHttpResponse *)getUserFollow:(NSNumber *) userId withLastUpdateTime:(NSString *) lastUpdateTime{
    NSString *url = [NSString stringWithFormat:USER_FOLLOWER_LIST_URL ,userId, lastUpdateTime];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)putUserFollows:userId withUserFollows:(NSMutableArray *) useFollows{
    NSString *url = [NSString stringWithFormat:PUT_USER_FOLLOWER_LIST_URL,userId];
    RORHttpResponse *httpResponse = [RORHttpClientHandler putRequest:url withRequstBody:[RORUtils toJsonFormObject:useFollows]];
    return httpResponse;
}

+(RORHttpResponse *)getUserPlanHistory:(NSNumber *) userId withLastUpdateTime:(NSString *) lastUpdateTime{
    NSString *url = [NSString stringWithFormat:USER_PLAN_HISTORY_URL ,userId, lastUpdateTime];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)getPlanUsingListByPlanId:(NSNumber *) planId withPageNo:(NSNumber *) pageNo{
    NSString *url = [NSString stringWithFormat:PLAN_HISTORY_BY_PLANID_URL ,planId, pageNo];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)getPlanUsingListByUserId:(NSNumber *) userId withPageNo:(NSNumber *) pageNo{
    NSString *url = [NSString stringWithFormat:PLAN_HISTORY_BY_USERID_URL ,userId, pageNo];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)getUserLastUpdatingPlan:(NSNumber *) userId{
    NSString *url = [NSString stringWithFormat:USER_LAST_UPDATE_PLAN_URL ,userId];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)putUserPlanHistory:userId withPlanHistory:(NSMutableArray *) planHistory{
    NSString *url = [NSString stringWithFormat:PUT_USER_PLAN_HISTORY_URL,userId];
    RORHttpResponse *httpResponse = [RORHttpClientHandler putRequest:url withRequstBody:[RORUtils toJsonFormObject:planHistory]];
    return httpResponse;
}


@end
