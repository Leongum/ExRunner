//
//  RORRunHistoryServices.m
//  RevolUtioN
//
//  Created by leon on 13-7-22.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORRunHistoryServices.h"

@implementation RORRunHistoryServices

+(NSArray*)fetchRunHistoryByUserId:(NSNumber*)userId{
    return [self fetchRunHistoryByUserId:userId withContext:NO];
}

+(NSArray*)fetchRunHistoryByUserId:(NSNumber*)userId withContext:(BOOL) needContext{
    NSString *table=@"User_Running_History";
    NSString *query = @"userId = %@";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if(!needContext){
        NSMutableArray *historyList = [[NSMutableArray alloc] init];
        for (User_Running_History *histroy in fetchObject) {
            [historyList addObject:[User_Running_History removeAssociateForEntity:histroy]];
        }
        return [historyList copy];
    }
    return fetchObject;
}

+(NSArray*)fetchRunHistory{
    NSNumber *userId = [RORUserUtils getUserId];
    NSArray *fetchObject = [self fetchRunHistoryByUserId:userId];
    return fetchObject;
}

+(NSArray *)fetchUnsyncedRunHistories:(BOOL) needContext{
    
    NSNumber *userId = [RORUserUtils getUserId];
    
    NSString *table=@"User_Running_History";
    NSString *query = @"(userId = %@ or userId = -1) and commitDate.length <= 0";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if(!needContext){
        NSMutableArray *historyList = [[NSMutableArray alloc] init];
        for (User_Running_History *histroy in fetchObject) {
            User_Running_History *newHistory = [User_Running_History removeAssociateForEntity:histroy];
            newHistory.userId = userId;
            [historyList addObject:newHistory];
        }
        return [historyList copy];
    }
    return fetchObject;
}

+(NSArray *)fetchUnsyncedUserRunning:(BOOL) needContext{
    
    NSNumber *userId = [RORUserUtils getUserId];
    
    NSString *table=@"User_Running";
    NSString *query = @"(userId = %@ or userId = -1) and commitDate.length <= 0";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if(!needContext){
        NSMutableArray *historyList = [[NSMutableArray alloc] init];
        for (User_Running *histroy in fetchObject) {
            User_Running *newHistory = [User_Running removeAssociateForEntity:histroy];
            newHistory.userId = userId;
            [historyList addObject:newHistory];
        }
        return [historyList copy];
    }
    return fetchObject;
    
}

+(void)updateUnsyncedRunHistories{
    NSNumber *userId = [RORUserUtils getUserId];
    NSArray *fetchObject = [self fetchUnsyncedRunHistories:YES];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return;
    }
    for (User_Running_History *info in fetchObject) {
        info.userId = userId;
        info.commitTime = [RORUserUtils getSystemTime];
    }
    [RORContextUtils saveContext];
}

+(void)updateUnsyncedUserRunning{
    NSNumber *userId = [RORUserUtils getUserId];
    NSArray *fetchObject = [self fetchUnsyncedUserRunning:YES];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return;
    }
    for (User_Running *info in fetchObject) {
        info.userId = userId;
        info.commitTime = [RORUserUtils getSystemTime];
    }
    [RORContextUtils saveContext];
}

+(User_Running_History *)fetchRunHistoryByRunId:(NSString *) runId{    
    return [self fetchRunHistoryByRunId:runId withContext:NO];
}

+(User_Running_History *)fetchRunHistoryByRunId:(NSString *) runId withContext:(BOOL) needContext{
    
    NSString *table=@"User_Running_History";
    NSString *query = @"runUuid = %@";
    NSArray *params = [NSArray arrayWithObjects:runId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if (!needContext) {
        return [User_Running_History removeAssociateForEntity:(User_Running_History *) [fetchObject objectAtIndex:0]];
    }
    return (User_Running_History *) [fetchObject objectAtIndex:0];
    
}

+(User_Running *)fetchUserRunningByRunId:(NSString *) runId{
    return [self fetchUserRunningByRunId:runId withContext:NO];
}

+(User_Running *)fetchUserRunningByRunId:(NSString *) runId withContext:(BOOL) needContext{
    NSString *table=@"User_Running";
    NSString *query = @"runUuid = %@";
    NSArray *params = [NSArray arrayWithObjects:runId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if (!needContext) {
        return [User_Running removeAssociateForEntity:(User_Running *) [fetchObject objectAtIndex:0]];
    }
    return (User_Running *) [fetchObject objectAtIndex:0];
}

+ (Boolean)uploadRunningHistories{
    NSNumber *userId = [RORUserUtils getUserId];
    NSArray *dataList = [self fetchUnsyncedRunHistories:NO];
    RORHttpResponse *httpResponse = [RORRunHistoryClientHandler createRunHistories:userId withRunHistories:dataList];
    
    if ([httpResponse responseStatus] == 200){
        [self updateUnsyncedRunHistories];
        
    } else {
        NSLog(@"error: statCode = %@", [httpResponse errorMessage]);
        return NO;
    }
    return YES;
}

+ (Boolean)syncRunningHistories{
    NSError *error = nil;
    NSNumber *userId = [RORUserUtils getUserId];
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"RunningHistoryUpdateTime"];
    
    RORHttpResponse *httpResponse =[RORRunHistoryClientHandler getRunHistories:userId withLastUpdateTime:lastUpdateTime];
    
    if ([httpResponse responseStatus]  == 200){
        NSArray *runHistoryList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *runHistoryDict in runHistoryList){
            NSString *runUuid = [runHistoryDict valueForKey:@"runUuid"];
            User_Running_History *runHistoryEntity = [self fetchRunHistoryByRunId:runUuid withContext:YES];
            if(runHistoryEntity == nil)
                runHistoryEntity = [NSEntityDescription insertNewObjectForEntityForName:@"User_Running_History" inManagedObjectContext:[RORContextUtils getShareContext]];
            [runHistoryEntity initWithDictionary:runHistoryDict];
        }
        [RORContextUtils saveContext];
        [RORUserUtils saveLastUpdateTime:@"RunningHistoryUpdateTime"];
    } else {
        NSLog(@"sync with host error: can't get mission list. Status Code: %d", [httpResponse responseStatus]);
        return NO;
    }
    return YES;
}

+ (void) saveRunInfoToDB:(User_Running_History *)runningHistory{
    //check uuid
    if(runningHistory.runUuid != nil){
        NSManagedObjectContext *context = [RORContextUtils getShareContext];
        User_Running_History *runHistory = [NSEntityDescription insertNewObjectForEntityForName:@"User_Running_History" inManagedObjectContext:context];
        //loop through all attributes and assign then to the clone
        NSDictionary *attributes = [[NSEntityDescription
                                     entityForName:@"User_Running_History"
                                     inManagedObjectContext:context] attributesByName];
        
        for (NSString *attr in [attributes allKeys]) {
            [runHistory setValue:[runningHistory valueForKey:attr] forKey:attr];
        }
        [RORContextUtils saveContext];
    }
}

+ (void)uploadUserRunning{
    NSNumber *userId = [RORUserUtils getUserId];
    NSArray *dataList = [self fetchUnsyncedUserRunning:NO];
    RORHttpResponse *httpResponse = [RORRunHistoryClientHandler createUserRunning:userId withUserRun:dataList];
    
    if ([httpResponse responseStatus] == 200){
        [self updateUnsyncedUserRunning];
        
    } else {
        //todo: add existing check
        NSLog(@"error: statCode = %@", [httpResponse errorMessage]);
    }
}


+ (Boolean)syncUserRunning{
    NSError *error = nil;
    NSNumber *userId = [RORUserUtils getUserId];
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"UserRunningUpdateTime"];
    
    RORHttpResponse *httpResponse =[RORRunHistoryClientHandler getUserRunning:userId withLastUpdateTime:lastUpdateTime];
    
    if ([httpResponse responseStatus]  == 200){
        NSArray *runHistoryList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *userRunningDict in runHistoryList){
            NSString *runUuid = [userRunningDict valueForKey:@"runUuid"];
            User_Running *userRunningEntity = [self fetchUserRunningByRunId:runUuid withContext:YES];
            if(userRunningEntity == nil)
                userRunningEntity = [NSEntityDescription insertNewObjectForEntityForName:@"User_Running" inManagedObjectContext:[RORContextUtils getShareContext]];
            [userRunningEntity initWithDictionary:userRunningDict];
        }
        [RORContextUtils saveContext];
        [RORUserUtils saveLastUpdateTime:@"UserRunningUpdateTime"];
    } else {
        NSLog(@"sync with host error: can't get mission list. Status Code: %d", [httpResponse responseStatus]);
        return NO;
    }
    return YES;
}

@end
