//
//  RORRunHistoryClientHandler.m
//  RevolUtioN
//
//  Created by leon on 13-7-22.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORRunHistoryClientHandler.h"

@implementation RORRunHistoryClientHandler

+(RORHttpResponse *)createRunHistories:(NSNumber *) userId withRunHistories:(NSArray *) runHistories{
    NSString *requestUrl = [NSString stringWithFormat:POST_RUNNING_HISTORY_URL, userId];
    RORHttpResponse *httpResponse = [RORHttpClientHandler postRequest:requestUrl withRequstBody:[RORUtils toJsonFormObject:runHistories]];
    return httpResponse;
}

+(RORHttpResponse *)getRunHistories:(NSNumber *)userId withLastUpdateTime:(NSString *) lastUpdateTime{
    NSString *url = [NSString stringWithFormat:RUNNING_HISTORY_URL, userId, lastUpdateTime];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)createUserRunning:(NSNumber *) userId withUserRun:(NSArray *) userRunning{
    NSString *requestUrl = [NSString stringWithFormat:POST_USER_RUNNING_URL, userId];
    RORHttpResponse *httpResponse = [RORHttpClientHandler postRequest:requestUrl withRequstBody:[RORUtils toJsonFormObject:userRunning]];
    return httpResponse;
}

+(RORHttpResponse *)getUserRunning:(NSNumber *)userId withLastUpdateTime:(NSString *) lastUpdateTime{
    NSString *url = [NSString stringWithFormat:USER_RUNNING_URL, userId, lastUpdateTime];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

@end
