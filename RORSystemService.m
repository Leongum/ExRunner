//
//  RORSystemService.m
//  RevolUtioN
//
//  Created by leon on 13-8-10.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORSystemService.h"

@implementation RORSystemService

+ (Version_Control *)fetchVersionInfo:(NSString *) platform{
    return [self fetchVersionInfo:platform withContext:NO];
}

+ (Version_Control *)fetchVersionInfo:(NSString *) platform withContext:(BOOL) needContext{
    
    NSString *table=@"Version_Control";
    NSString *query = @"platform = %@";
    NSArray *params = [NSArray arrayWithObjects:platform, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if(!needContext){
        return [Version_Control removeAssociateForEntity:(Version_Control *) [fetchObject objectAtIndex:0]];
    }
    return  (Version_Control *) [fetchObject objectAtIndex:0];
}

+ (System_Message *)fetchSystemMessageInfo:(NSNumber *) messageId{
    return [self fetchSystemMessageInfo:messageId withContext:NO];
}

+ (System_Message *)fetchSystemMessageInfo:(NSNumber *) messageId withContext:(BOOL) needContext{
    
    NSString *table=@"System_Message";
    NSString *query = @"messageId = %@";
    NSArray *params = [NSArray arrayWithObjects:messageId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if(!needContext){
        return [System_Message removeAssociateForEntity:(System_Message *) [fetchObject objectAtIndex:0]];
    }
    return  (System_Message *) [fetchObject objectAtIndex:0];
}

+ (void) saveSystimeTime:(NSString *)systemTime{
    NSMutableDictionary *userDict = [RORUserUtils getUserInfoPList];
    [userDict setValue:systemTime forKey:@"systemTime"];
    [RORUserUtils writeToUserInfoPList:userDict];
}

+(Version_Control *)syncVersion:(NSString *)platform{
    NSError *error = nil;
    RORHttpResponse *httpResponse =[RORSystemClientHandler getVersionInfo:platform];
    
    if ([httpResponse responseStatus] == 200){
        NSDictionary *versionInfo = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        Version_Control *versionEntity = [self fetchVersionInfo:platform withContext:YES];
        NSLog(@"%@",versionEntity.systemTime);
        NSLog(@"%@",versionEntity.version);
        if(versionEntity == nil)
            versionEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Version_Control" inManagedObjectContext:[RORContextUtils getShareContext]];
        [versionEntity initWithDictionary:versionInfo];
        
        [RORContextUtils saveContext];
        NSLog(@"%@",versionEntity.systemTime);
        [self saveSystimeTime:[RORUtils getStringFromDate:versionEntity.systemTime]];
        return [self fetchVersionInfo:platform];
    } else {
        NSLog(@"sync with host error: can't get version info. Status Code: %d", [httpResponse responseStatus]);
    }
    return nil;
}

+ (BOOL)syncSystemMessage{
    NSError *error = nil;
    NSManagedObjectContext *context = [RORContextUtils getShareContext];
    NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"SystemMessageUpdateTime"];
    
    RORHttpResponse *httpResponse =[RORSystemClientHandler getSystemMessage:lastUpdateTime];
    
    if ([httpResponse responseStatus]  == 200){
        NSArray *messageList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        for (NSDictionary *messageDict in messageList){
            NSNumber *messageId = [messageDict valueForKey:@"messageId"];
            System_Message *messageEntity = [self fetchSystemMessageInfo:messageId withContext:YES];
            if(messageEntity == nil)
                messageEntity = [NSEntityDescription insertNewObjectForEntityForName:@"System_Message" inManagedObjectContext:context];
            [messageEntity initWithDictionary:messageDict];
        }
        
        [RORContextUtils saveContext];
        [RORUserUtils saveLastUpdateTime:@"SystemMessageUpdateTime"];
    } else {
        NSLog(@"sync with host error: can't get sync message list. Status Code: %d", [httpResponse responseStatus]);
        return NO;
    }
    return YES;
}

+ (NSString *)getSystemMessage:(NSNumber *)messageId {
   return [self getSystemMessage:messageId withRegion:nil];
}

+ (NSString *)getSystemMessage:(NSNumber *)messageId withRegion:(NSNumber *)region{
    NSString *result = @"";
    System_Message *message = [self fetchSystemMessageInfo:messageId];
    //if have no messages do sync
    if(message == nil){
        [self syncSystemMessage];
        message = [self fetchSystemMessageInfo:messageId];
    }
    //logic to return message
    if(message != nil){
        result = message.message;
        if(region != nil && [message.rule length] != 0){
            NSArray *messageArray = [message.message componentsSeparatedByString:@"|"];
            NSArray *ruleArray = [message.rule componentsSeparatedByString:@"|"];
            if([messageArray count] == [ruleArray count] && [ruleArray count] > 1){
                for (int i = 0; i< [ruleArray count]; i++)
                {
                    NSArray *ruleDetails = [(NSString *)[ruleArray objectAtIndex:i] componentsSeparatedByString:@","];
                    double left = ((NSNumber *)[ruleDetails objectAtIndex:0]).doubleValue;
                    double right = ((NSNumber *)[ruleDetails objectAtIndex:1]).doubleValue;
                    if(region.doubleValue <= right &&  region.doubleValue > left){
                        result = (NSString *)[messageArray objectAtIndex:i];
                    }
                }
            }
        }
    }
    //default value is empty
    return result;
}

+(BOOL)submitFeedback:(NSDictionary *)feedbackDic{
    RORHttpResponse *httpResponse = [RORSystemClientHandler submitFeedback:feedbackDic];
    if ([httpResponse responseStatus] == 200){
        return YES;
    } else {
        return NO;
    }
}

@end
