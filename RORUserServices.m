//
//  RORUserServices.m
//  RevolUtioN
//
//  Created by leon on 13-7-14.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORUserServices.h"
#import "RORNetWorkUtils.h"

@implementation RORUserServices

+ (User_Base *)fetchUserById:(NSNumber *) userId{
    return  [self fetchUserById:userId withContext:NO];
}

+ (User_Base *)fetchUserById:(NSNumber *) userId withContext:(BOOL) needContext{
    NSString *table=@"User_Base";
    NSString *query = @"userId = %@";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if (!needContext) {
        return [User_Base removeAssociateForEntity:(User_Base *) [fetchObject objectAtIndex:0]];
    }
    return  (User_Base *) [fetchObject objectAtIndex:0];
}

+(User_Attributes *)fetchUserAttrsByUserId:(NSNumber *) userId{
    return [self fetchUserAttrsByUserId:userId withContext:NO];
}

+(User_Attributes *)fetchUserAttrsByUserId:(NSNumber *) userId withContext:(BOOL) needContext{
    NSString *table=@"User_Attributes";
    NSString *query = @"userId = %@";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    
    if (!needContext) {
        return[User_Attributes removeAssociateForEntity:(User_Attributes *) [fetchObject objectAtIndex:0]];
    }
    return   (User_Attributes *) [fetchObject objectAtIndex:0];
}

+(Friend *)fetchUserFriend:(NSNumber *) userId withFriendId:(NSNumber *) friendId{
    return [self fetchUserFriend:userId withFriendId:friendId withContext:NO];
}

+(Friend *)fetchUserFriend:(NSNumber *) userId withFriendId:(NSNumber *) friendId withContext:(BOOL) needContext{
    NSString *table=@"Friend";
    NSString *query = @"userId = %@ and friendId = %@";
    NSArray *params = [NSArray arrayWithObjects:userId,friendId, nil];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    if (!needContext) {
        return[Friend removeAssociateForEntity:(Friend *) [fetchObject objectAtIndex:0]];
    }
    return (Friend *) [fetchObject objectAtIndex:0];
}

+ (User_Base *)fetchUser:(NSNumber *) userId{
    User_Base *user = [self fetchUserById:userId];
    if(user != nil){
        user.attributes = [self fetchUserAttrsByUserId:userId];
    }
    return user;
}

+(User_Base *)registerUser:(NSDictionary *)registerDic{
    RORHttpResponse *httpResponse = [RORUserClientHandler createUserInfoByUserDic:registerDic];
    User_Base *userBase = [self syncUserFromResponse:httpResponse];
    [self saveUserInfoToList:userBase];
    return userBase;
}

+(User_Base *)updateUserInfo:(NSDictionary *)updateDic{
    RORHttpResponse *httpResponse = [RORUserClientHandler updateUserBaseInfo:[RORUserUtils getUserId] withUserInfo:updateDic];
    User_Base *userBase = [self syncUserFromResponse:httpResponse];
    [self saveUserInfoToList:userBase];
    return userBase;
}

+(User_Base *)syncUserInfoById:(NSNumber *)userId{
    if(userId <= 0) return nil;
    RORHttpResponse *httpResponse =[RORUserClientHandler getUserInfoById:userId];
    return [self syncUserFromResponse:httpResponse];
}

+(User_Base *)syncUserInfoByLogin:(NSString *)userName withUserPasswordL:(NSString *) password{
    if(userName == nil || password == nil) return nil;
    RORHttpResponse *httpResponse = [RORUserClientHandler getUserInfoByUserNameAndPassword:userName withPassword:password];
    User_Base *userBase = [self syncUserFromResponse:httpResponse];
    [self saveUserInfoToList:userBase];
    return userBase;
}


+ (void) saveUserInfoToList:(User_Base *)user{
    NSMutableDictionary *userDict = [RORUserUtils getUserInfoPList];
    [userDict setValue:user.userId forKey:@"userId"];
    [userDict setValue:user.nickName forKey:@"nickName"];
    [userDict setValue:user.uuid forKey:@"uuid"];
    [RORUserUtils writeToUserInfoPList:userDict];
    
    NSMutableDictionary *settingDict = [RORUserUtils getUserSettingsPList];
    [settingDict setValue:user.sex forKey:@"sex"];
    [settingDict setValue:user.attributes.weight forKey:@"weight"];
    [settingDict setValue:user.attributes.height forKey:@"height"];
    [RORUserUtils writeToUserSettingsPList:settingDict];
}

+(User_Base *)syncUserFromResponse:(RORHttpResponse *)httpResponse{
    NSError *error;
    User_Base *user = nil;
    
    if ([httpResponse responseStatus] == 200){
        NSDictionary *userInfoDic = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
        
        NSNumber *userId = [userInfoDic valueForKey:@"userId"];
        
        user = [self fetchUserById:userId withContext:YES];
        User_Attributes *userAttr = [self fetchUserAttrsByUserId:userId withContext:YES];
        
        if(user == nil)
            user = [NSEntityDescription insertNewObjectForEntityForName:@"User_Base" inManagedObjectContext:[RORContextUtils getShareContext]];
        [user initWithDictionary:userInfoDic];
        
        if(userAttr == nil)
            userAttr = [NSEntityDescription insertNewObjectForEntityForName:@"User_Attributes" inManagedObjectContext:[RORContextUtils getShareContext]];
        [userAttr initWithDictionary:userInfoDic];
        
        [RORContextUtils saveContext];
        user.attributes = userAttr;
    }
    else if([httpResponse responseStatus] == 406 && [[httpResponse errorMessage] isEqualToString:@"LOGIN_CHECK_FAIL"]){
        [RORUserUtils logout];
    }else {
        NSLog(@"sync with host error: can't get user's info. Status Code: %d", [httpResponse responseStatus]);
        return user;
    }
    return [User_Base removeAssociateForEntity:user];
}

+ (BOOL)syncFriends:(NSNumber *) userId {
    if(userId > 0)
    {
        NSError *error = nil;
        NSManagedObjectContext *context = [RORContextUtils getShareContext];
        NSString *lastUpdateTime = [RORUserUtils getLastUpdateTime:@"FriendUpdateTime"];
        RORHttpResponse *httpResponse =[RORUserClientHandler getUserFriends:userId withLastUpdateTime:lastUpdateTime];
        
        if ([httpResponse responseStatus] == 200){
            NSArray *friendList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
            for (NSDictionary *friendDict in friendList){
                NSNumber *userIdNum = [friendDict valueForKey:@"userId"];
                NSNumber *friendIdNum = [friendDict valueForKey:@"friendId"];
                Friend *friendEntity = [self fetchUserFriend:userIdNum withFriendId:friendIdNum withContext:YES];
                if(friendEntity == nil)
                    friendEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:context];
                [friendEntity initWithDictionary:friendDict];
            }
            
            [RORContextUtils saveContext];
            [RORUserUtils saveLastUpdateTime:@"FriendUpdateTime"];
            return YES;
        } else {
            NSLog(@"sync with host error: can't get user's friends list. Status Code: %d", [httpResponse responseStatus]);
        }
    }
    return NO;
}

+(void)clearUserData{
    NSArray *tables = [NSArray arrayWithObjects:@"User",@"User_Attributes",@"Friend",@"User_Last_Location",@"User_Running_History",@"User_Running", nil];
    [RORContextUtils clearTableData:tables];
}

+(BOOL)syncFollowersDetails:(NSNumber *) userId withPageNo:(NSNumber *) pageNo{
    if(userId.integerValue > 0){
        NSError *error = nil;
        NSManagedObjectContext *context = [RORContextUtils getShareContext];
        RORHttpResponse *httpResponse =[RORUserClientHandler getFollowerDetails:userId withPageNo:pageNo];
        if ([httpResponse responseStatus] == 200){
            NSArray *userList = [NSJSONSerialization JSONObjectWithData:[httpResponse responseData] options:NSJSONReadingMutableLeaves error:&error];
            for (NSDictionary *userDict in userList){
                NSNumber *userIdNum = [userDict valueForKey:@"userId"];
                User_Base *userEntity = [self fetchUserById:userIdNum withContext:YES];
                User_Attributes *userAttributesEntity = [self fetchUserAttrsByUserId:userIdNum withContext:YES];
                if(userEntity == nil)
                    userEntity = [NSEntityDescription insertNewObjectForEntityForName:@"User_Base" inManagedObjectContext:context];
                if(userAttributesEntity == nil)
                    userAttributesEntity = [NSEntityDescription insertNewObjectForEntityForName:@"User_Attributes" inManagedObjectContext:context];
                [userEntity initWithDictionary:userDict];
                [userAttributesEntity initWithDictionary:userDict];
            }
            
            [RORContextUtils saveContext];
            return YES;
        } else {
            NSLog(@"sync with host error: can't get user's friends list. Status Code: %d", [httpResponse responseStatus]);
        }
    }
    return NO;
}

+(NSMutableArray *)fetchFollowersDetails:(NSNumber *) userId withPageNo:(NSNumber *) pageNo{
    NSString *table=@"Plan_User_Follow";
    NSString *query = @"userId = %@ and status = 0";
    NSArray *params = [NSArray arrayWithObjects:userId, nil];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"addTime" ascending:NO];
    NSArray *sortParams = [NSArray arrayWithObject:sortDescriptor];
    NSArray *fetchObject = [RORContextUtils fetchFromDelegate:table withParams:params withPredicate:query withOrderBy:sortParams withLimit:FRIENDS_PAGE_SIZE];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    NSMutableArray *followerDetails = [NSMutableArray arrayWithCapacity:FRIENDS_PAGE_SIZE];
    for (Plan_User_Follow *userFollower in fetchObject) {
        NSNumber *followUserId =  userFollower.followUserId;
        User_Base *userfollow = [self fetchUser:followUserId];
        if (userfollow)
            [followerDetails addObject: userfollow];
    }
    return followerDetails;
}

@end
