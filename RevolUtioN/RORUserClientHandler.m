//
//  RORUserClientHandler.m
//  RevolUtioN
//
//  Created by leon on 13-7-15.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORUserClientHandler.h"

@implementation RORUserClientHandler

+(RORHttpResponse *)getUserInfoByUserNameAndPassword:(NSString *) userName withPassword:(NSString *) password{
    NSString *url = [NSString stringWithFormat:LOGIN_URL ,userName, password];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

+(RORHttpResponse *)createUserInfoByUserDic:(NSDictionary *) userInfo{
    RORHttpResponse *httpResponse = [RORHttpClientHandler postRequest:REGISTER_URL withRequstBody:[RORUtils toJsonFormObject:userInfo]];
    return httpResponse;
}

+(RORHttpResponse *)getUserFriends:(NSNumber *) userId withLastUpdateTime:(NSString *) lastUpdateTime{
    NSString *url = [NSString stringWithFormat:FRIEND_URL ,userId, lastUpdateTime];
    RORHttpResponse *httpResponse = [RORHttpClientHandler getRequest:url];
    return httpResponse;
}

@end
