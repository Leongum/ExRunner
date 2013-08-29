//
//  RORNetWorkUtils.m
//  RevolUtioN
//
//  Created by leon on 13-8-29.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORNetWorkUtils.h"

static NetworkStatus networkStatus = NotReachable;

static BOOL doUploadable = NO;

static BOOL isConnectioned = NO;

@implementation RORNetWorkUtils

+ (BOOL) getDoUploadable{
    return doUploadable;
}

+ (BOOL) getIsConnetioned{
    return isConnectioned;
}

+ (void) initCheckNetWork{
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [self updateNetWorkStatus:[reach currentReachabilityStatus]];
}

+ (void) updateNetWorkStatus:(NetworkStatus) newNetWorkStatus{
    BOOL isExistenceNetwork = YES;
    switch (newNetWorkStatus) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
    }
    isConnectioned = isExistenceNetwork;
    networkStatus = newNetWorkStatus;
    NSMutableDictionary *settingDict = [RORUserUtils getUserSettingsPList];
    if(isConnectioned){
        if(settingDict == nil){
                doUploadable = YES;
        }
        else{
            NSString *updatemode = [settingDict valueForKey:@"uploadMode"];
            if([NET_WORK_MODE isEqualToString: updatemode]){
                doUploadable = YES;
            }
        }
    }

}

@end
