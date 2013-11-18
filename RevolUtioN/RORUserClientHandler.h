//
//  RORUserClientHandler.h
//  RevolUtioN
//
//  Created by leon on 13-7-15.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RORConstant.h"
#import "RORUserUtils.h"
#import "RORHttpClientHandler.h"
#import "RORHttpResponse.h"

@interface RORUserClientHandler : NSObject

+(RORHttpResponse *)getUserInfoByUserNameAndPassword:(NSString *) userName withPassword:(NSString *) password;

+(RORHttpResponse *)createUserInfoByUserDic:(NSDictionary *) userInfo;

+(RORHttpResponse *)getUserFriends:(NSNumber *) userId withLastUpdateTime:(NSString *) lastUpdateTime;

+(RORHttpResponse *)getUserInfoById:(NSNumber *) userId;

+(RORHttpResponse *)updateUserBaseInfo:(NSNumber *)userId withUserInfo:(NSDictionary *) userInfo;

+(RORHttpResponse *)getFollowerDetails:(NSNumber *) userId withPageNo:(NSNumber *) pageNo;

@end
