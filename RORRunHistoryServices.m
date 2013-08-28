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
    NSString *table=@"User_Running_History";
    NSString *query = @"userId = %@";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    return fetchObject;
}

+(NSArray*)fetchRunHistory{
    NSNumber *userId = [RORUserUtils getUserId];
    NSArray *fetchObject = [self fetchRunHistoryByUserId:userId];
    return fetchObject;
}

+(NSMutableArray *)fetchUnsyncedRunHistories{
    
    NSNumber *userId = [RORUserUtils getUserId];
    
    NSString *table=@"User_Running_History";
    NSString *query = @"(userId = %@ or userId = -1) and commitDate.length <= 0";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    NSMutableArray *dataList = [[NSMutableArray alloc]init];
    for (User_Running_History *info in fetchObject) {
        info.userId = userId;
        [dataList addObject:[info transToDictionary]];
    }
    return dataList;
    
}

+(NSMutableArray *)fetchUnsyncedUserRunning{
    
    NSNumber *userId = [RORUserUtils getUserId];
    
    NSString *table=@"User_Running";
    NSString *query = @"(userId = %@ or userId = -1) and commitDate.length <= 0";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    NSMutableArray *dataList = [[NSMutableArray alloc]init];
    for (User_Running *info in fetchObject) {
        info.userId = userId;
        [dataList addObject:[info transToDictionary]];
    }
    return dataList;
    
}

+(void)updateUnsyncedRunHistories{
    NSError *error;
    NSNumber *userId = [RORUserUtils getUserId];
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Running_History" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSArray *arrayFilter = [NSArray arrayWithObjects:userId, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId = %@ or userId = -1) and commitDate.length <= 0" argumentArray:arrayFilter];
    [fetchRequest setPredicate:predicate];
    NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return;
    }
    for (User_Running_History *info in fetchObject) {
        info.userId = userId;
        info.commitTime = [RORUserUtils getSystemTime];
    }
    if (![context save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
}

+(void)updateUnsyncedUserRunning{
    NSError *error;
    NSNumber *userId = [RORUserUtils getUserId];
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User_Running" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSArray *arrayFilter = [NSArray arrayWithObjects:userId, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId = %@ or userId = -1) and commitDate.length <= 0" argumentArray:arrayFilter];
    [fetchRequest setPredicate:predicate];
    NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return;
    }
    for (User_Running *info in fetchObject) {
        info.userId = userId;
        info.commitTime = [RORUserUtils getSystemTime];
    }
    if (![context save:&error]) {
        NSLog(@"%@",[error localizedDescription]);
    }
}

+(User_Running_History *)fetchRunHistoryByRunId:(NSString *) runId{
    
    NSString *table=@"User_Running_History";
    NSString *query = @"runUuid = %@";
    NSArray *params = [NSArray arrayWithObjects:runId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    return (User_Running_History *) [fetchObject objectAtIndex:0];
    
}

+(User_Running *)fetchUserRunningByRunId:(NSString *) runId{
    NSString *table=@"User_Running";
    NSString *query = @"runUuid = %@";
    NSArray *params = [NSArray arrayWithObjects:runId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    return (User_Running *) [fetchObject objectAtIndex:0];

    
}

+ (Boolean)uploadRunningHistories{
    NSNumber *userId = [RORUserUtils getUserId];
    NSMutableArray *dataList = [self fetchUnsyncedRunHistories];
    RORHttpResponse *httpResponse = [RORRunHistoryClientHandler createRunHistories:userId withRunHistories:dataList];
    
    if ([httpResponse responseStatus] == 200){
        [self updateUnsyncedRunHistories];
        
    } else {
        //todo: add existing check
        NSLog(@"error: statCode = %@", [httpResponse errorMessage]);
        return NO;
    }
    return YES;
}

+ (Boolean)syncRunningHistories{
    NSError *error = nil;
    NSNumber *userId = [RORUserUtils getUserId];
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"RunningHistoryUpdateTime"];
    
    RORHttpResponse *httpResponse =[RORRunHistoryClientHandler getRunHistories:userId withLastUpdateTime:lastUpdateTime];
    
    if ([httpResponse responseStatus]  == 200){
        NSArray *runHistoryList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *runHistoryDict in runHistoryList){
            NSString *runUuid = [runHistoryDict valueForKey:@"runUuid"];
            User_Running_History *runHistoryEntity = [self fetchRunHistoryByRunId:runUuid];
            if(runHistoryEntity == nil)
                runHistoryEntity = [NSEntityDescription insertNewObjectForEntityForName:@"User_Running_History" inManagedObjectContext:context];
            [runHistoryEntity initWithDictionary:runHistoryDict];
        }
        if (![context save:&error]) {
            NSLog(@"%@",[error localizedDescription]);
        }
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
        NSError *error = nil;
        RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = delegate.managedObjectContext;
        User_Running_History *runHistory = [NSEntityDescription insertNewObjectForEntityForName:@"User_Running_History" inManagedObjectContext:context];
        //loop through all attributes and assign then to the clone
        NSDictionary *attributes = [[NSEntityDescription
                                     entityForName:@"User_Running_History"
                                     inManagedObjectContext:context] attributesByName];
        
        for (NSString *attr in [attributes allKeys]) {
            [runHistory setValue:[runningHistory valueForKey:attr] forKey:attr];
        }
        @try{
        if (![context save:&error]) {
            NSLog(@"%@",[error localizedDescription]);
        }
        }
        @catch(NSException *ex){
            NSLog(@"%@",[ex reason]);
        }
    }
}

+ (void)uploadUserRunning{
    NSNumber *userId = [RORUserUtils getUserId];
    NSMutableArray *dataList = [self fetchUnsyncedUserRunning];
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
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"UserRunningUpdateTime"];
    
    RORHttpResponse *httpResponse =[RORRunHistoryClientHandler getUserRunning:userId withLastUpdateTime:lastUpdateTime];
    
    if ([httpResponse responseStatus]  == 200){
        NSArray *runHistoryList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *userRunningDict in runHistoryList){
            NSString *runUuid = [userRunningDict valueForKey:@"runUuid"];
            User_Running *userRunningEntity = [self fetchUserRunningByRunId:runUuid];
            if(userRunningEntity == nil)
                userRunningEntity = [NSEntityDescription insertNewObjectForEntityForName:@"User_Running" inManagedObjectContext:context];
            [userRunningEntity initWithDictionary:userRunningDict];
        }
        if (![context save:&error]) {
            NSLog(@"%@",[error localizedDescription]);
        }
        [RORUserUtils saveLastUpdateTime:@"UserRunningUpdateTime"];
    } else {
        NSLog(@"sync with host error: can't get mission list. Status Code: %d", [httpResponse responseStatus]);
        return NO;
    }
    return YES;
}

@end
