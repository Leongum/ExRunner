//
//  RORShareService.m
//  RevolUtioN
//
//  Created by leon on 13-8-15.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORShareService.h"

@implementation RORShareService

//login return YES, register return NO.
+ (BOOL)loginFromSNS:(id<ISSUserInfo>)userInfo withSNSType:(ShareType) type{
    User_Base *user = [User_Base intiUnassociateEntity];
    user.userEmail = [userInfo uid];
    user.nickName = [userInfo nickname];
    if([userInfo gender] == 1){
        user.sex = @"女";
    }
    else if([userInfo gender] == 2){
        user.sex = @"男";
    }
    else{
        user.sex = @"未知";
    }
    user.password = [RORUtils md5:user.userEmail];

    
    User_Base *loginUser = [RORUserServices syncUserInfoByLogin:user.userEmail withUserPasswordL:[RORUtils md5:user.password]];
    
    if (loginUser == nil){
        NSDictionary *regDict = [[NSDictionary alloc]initWithObjectsAndKeys:user.userEmail, @"userEmail",[RORUtils md5:user.password], @"password", user.nickName, @"nickName", user.sex, @"sex", nil];
        [RORUserServices registerUser:regDict];
        return NO;
    }
    return YES;
}

@end
