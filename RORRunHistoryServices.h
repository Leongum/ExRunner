//
//  RORRunHistoryServices.h
//  RevolUtioN
//
//  Created by leon on 13-7-22.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORAppDelegate.h"
#import "RORHttpResponse.h"
#import "RORMissionClientHandler.h"
#import "User_Running.h"
#import "User_Running_History.h"
#import "RORRunHistoryClientHandler.h"
#import "RORContextUtils.h"

@interface RORRunHistoryServices : NSObject

+ (User_Running_History *)fetchRunHistoryByRunId:(NSString *) runId;

+ (User_Running *)fetchUserRunningByRunId:(NSString *) runId;

+(User_Running_History *)fetchBestRunHistoryByMissionId:(NSNumber *)missionId withUserId:(NSNumber *)userId;

+ (BOOL)uploadRunningHistories;

+ (BOOL)syncRunningHistories:(NSNumber *)userId;

+ (BOOL)syncUserRunning;

+(NSArray*)fetchRunHistoryByUserId:(NSNumber*)userId;

+(NSArray*)fetchRunHistory;

+(BOOL)saveRunInfoToDB:(User_Running_History*)runHistory;

+(NSArray *)fetchRunHistoryByPlanRunUuid:(NSString *) planRunUuid onlyValid:(NSNumber *)onlyValid;


@end
