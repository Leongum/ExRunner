//
//  RORUserUtils.m
//  RevolUtioN
//
//  Created by leon on 13-8-28.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORUserUtils.h"

@implementation RORUserUtils

static NSNumber *userId = nil;

static NSDate *systemTime = nil;

+ (NSNumber *)getUserId{
    if (userId == nil || userId < 0){
        NSMutableDictionary *userDict = [self getUserInfoPList];
        userId = [userDict valueForKey:@"userId"];
    }
    if(userId == nil){
        userId = [NSNumber numberWithInteger:-1];
    }
    return userId;
}

+ (NSString *)getUserUuid{
    NSMutableDictionary *userDict = [self getUserInfoPList];
    NSString *uuid = (NSString *)[userDict objectForKey:@"uuid"];
    return uuid;
}

+(NSDate *)getSystemTime{
    if (systemTime == nil){
        NSMutableDictionary *userDict = [self getUserInfoPList];
        systemTime = [userDict valueForKey:@"systemTime"];    }
    return systemTime;
}

+ (void)resetUserId{
    userId = [[NSNumber alloc] initWithInt:-1];
}

+ (NSString*)getUserSettingsPList{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [ doc objectAtIndex:0 ];
    return [docPath stringByAppendingPathComponent:@"userSettings.plist"];
}

+ (NSString *)hasLoggedIn{
    NSMutableDictionary *userDict = [self getUserInfoPList];
    NSString *name = [userDict valueForKey:@"nickName"];
    
    if (!([name isEqual:@""] || name == nil))
        return name;
    else
        return nil;
}

+ (NSMutableDictionary *)getUserInfoPList{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [ doc objectAtIndex:0 ];
    NSString *path = [docPath stringByAppendingPathComponent:@"userInfo.plist"];
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if (userDict == nil)
        userDict = [[NSMutableDictionary alloc] init];
    
    return userDict;
}

+ (void)writeToUserInfoPList:(NSDictionary *) userDict{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [ doc objectAtIndex:0 ];
    NSString *path = [docPath stringByAppendingPathComponent:@"userInfo.plist"];
    NSMutableDictionary *pInfo = [self getUserInfoPList];
    [pInfo addEntriesFromDictionary:userDict];
    [pInfo writeToFile:path atomically:YES];
}

+ (void)logout{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [ doc objectAtIndex:0 ];
    NSString *path = [docPath stringByAppendingPathComponent:@"userInfo.plist"];
    NSMutableDictionary *logoutDict = [[NSMutableDictionary alloc] init];
    [logoutDict setValue:[self getLastUpdateTime:@"MissionUpdateTime"] forKey:@"MissionUpdateTime"];
    [logoutDict writeToFile:path atomically:YES];
}

+ (void)saveLastUpdateTime: (NSString *) key{
    NSMutableDictionary *userDict = [self getUserInfoPList];
    NSString *systemTime = (NSString *)[userDict objectForKey:@"systemTime"];
    [userDict setValue:systemTime forKey:key];
    [self writeToUserInfoPList:userDict];
}

+ (NSString *)getLastUpdateTime: (NSString *) key{
    NSMutableDictionary *userDict = [self getUserInfoPList];
    NSString *lastUpdateTime = (NSString *)[userDict objectForKey:key];
    if(lastUpdateTime == nil){
        lastUpdateTime = @"2000-01-01 00:00:00";
    }
    lastUpdateTime = [RORUtils getStringFromDate:[RORUtils getDateFromString:lastUpdateTime]];
    return lastUpdateTime;
}

+ (void)userInfoUpdateHandler:(id<ISSUserInfo>)userInfo withSNSType:(ShareType) shareType
{
    NSMutableArray *authList = [NSMutableArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()]];
    if (authList == nil)
    {
        authList = [NSMutableArray array];
    }
    
    NSString *platName = nil;
    switch (shareType)
    {
        case ShareTypeSinaWeibo:
            platName = @"新浪微博";
            break;
        case ShareTypeQQSpace:
            platName = @"QQ空间";
            break;
        case ShareTypeRenren:
            platName = @"人人网";
            break;
        case ShareTypeTencentWeibo:
            platName = @"腾讯微博";
            break;
        default:
            platName = @"未知";
    }
    BOOL hasExists = NO;
    for (int i = 0; i < [authList count]; i++)
    {
        NSMutableDictionary *item = [authList objectAtIndex:i];
        ShareType type = [[item objectForKey:@"type"] integerValue];
        if (type == shareType)
        {
            [item setObject:[userInfo nickname] forKey:@"username"];
            hasExists = YES;
            break;
        }
    }
    
    if (!hasExists)
    {
        NSDictionary *newItem = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 platName,
                                 @"title",
                                 [NSNumber numberWithInteger:shareType],
                                 @"type",
                                 [userInfo nickname],
                                 @"username",
                                 nil];
        [authList addObject:newItem];
    }
    
    [authList writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
}
@end
