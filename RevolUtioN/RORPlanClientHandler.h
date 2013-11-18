//
//  RORPlanClientHandler.h
//  Cyberace
//
//  Created by leon on 13-11-15.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORConstant.h"
#import "RORUserUtils.h"
#import "RORHttpClientHandler.h"
#import "RORHttpResponse.h"

@interface RORPlanClientHandler : NSObject

+(RORHttpResponse *)syncPlan:(NSNumber *) planId withLastUpdateTime:(NSString *) lastUpdateTime;

+(RORHttpResponse *)getPlansList:(NSNumber *) pageNo;

+(RORHttpResponse *)createSelfPlan:userId withPlan:(NSMutableDictionary *) planDic;

+(RORHttpResponse *)getUserCollect:(NSNumber *) userId withLastUpdateTime:(NSString *) lastUpdateTime;

+(RORHttpResponse *)putUserCollects:userId withUserCollect:(NSMutableArray *) userCollects;

+(RORHttpResponse *)getUserFollow:(NSNumber *) userId withLastUpdateTime:(NSString *) lastUpdateTime;

+(RORHttpResponse *)putUserFollows:userId withUserFollows:(NSMutableArray *) useFollows;

+(RORHttpResponse *)getUserPlanHistory:(NSNumber *) userId withLastUpdateTime:(NSString *) lastUpdateTime;

+(RORHttpResponse *)getPlanUsingListByPlanId:(NSNumber *) planId withPageNo:(NSNumber *) pageNo;

+(RORHttpResponse *)getPlanUsingListByUserId:(NSNumber *) userId withPageNo:(NSNumber *) pageNo;

+(RORHttpResponse *)getUserLastUpdatingPlan:(NSNumber *) userId;

+(RORHttpResponse *)putUserPlanHistory:userId withPlanHistory:(NSMutableArray *) planHistory;

@end
