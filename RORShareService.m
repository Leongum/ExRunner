//
//  RORShareService.m
//  RevolUtioN
//
//  Created by leon on 13-8-15.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORShareService.h"

@implementation RORShareService

+ (void)authLoginFromSNS:(ShareType) type{
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleModal
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    [authOptions setPowerByHidden:true];
    
    //在授权页面中添加关注官方微博
    switch (type) {
        case ShareTypeSinaWeibo:
            [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"Cyberace_赛跑乐"],
                                            SHARE_TYPE_NUMBER(type),
                                            nil]];
            break;
        default:
            break;
    }
    
    [ShareSDK getUserInfoWithType:type
                      authOptions:authOptions
                           result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
                               if (result)
                               {
                                   [self loginFromSNS:userInfo withSNSType: type];
                               }
                               else
                               {
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                       message:error.errorDescription
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"知道了"
                                                                             otherButtonTitles: nil];
                                   [alertView show];
                               }
                           }];
}

+ (void)loginFromSNS:(id<ISSUserInfo>)userInfo withSNSType:(ShareType) type{
    User_Base *user = [User_Base init];
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
    user.password = @"thirdpartypassword";
    
    User_Base *loginUser = [RORUserServices syncUserInfoByLogin:user.userEmail withUserPasswordL:[RORUtils md5:user.password]];
    
    if (loginUser == nil){
        NSDictionary *regDict = [[NSDictionary alloc]initWithObjectsAndKeys:user.userEmail, @"userEmail",[RORUtils md5:user.password], @"password", user.nickName, @"nickName", user.sex, @"sex", nil];
        [RORUserServices registerUser:regDict];
    }
}
@end
